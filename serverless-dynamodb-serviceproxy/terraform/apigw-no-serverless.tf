#
# This is how you can create an api gateway method with a custom request/response integration
# using just terraform.  In our opinion, this is a pretty annoying way to make api gateway
# resources, and in general Serverless should be used instead.  However, there are certain
# situations that cannot be handled in Serverless.  In this case, creating a "Scan" or "Query"
# type of integration request is not possible using the serverless-apigateway-service-proxy plugin
# at this time.
#


# Define: /feedback_terraform
resource "aws_api_gateway_resource" "feedback_terraform" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  parent_id   = aws_api_gateway_rest_api.apigw.root_resource_id
  path_part   = "feedback_terraform"
}

# Define: GET on /feedback_terraform
resource "aws_api_gateway_method" "feedback_terraform_get" {
  rest_api_id   = aws_api_gateway_rest_api.apigw.id
  resource_id   = aws_api_gateway_resource.feedback_terraform.id
  http_method   = "GET"
  authorization = "NONE"
}

# Define: What to do when you GET /feedback_terraform
resource "aws_api_gateway_integration" "feedback_terraform_get" {
  rest_api_id             = aws_api_gateway_rest_api.apigw.id
  resource_id             = aws_api_gateway_resource.feedback_terraform.id
  http_method             = aws_api_gateway_method.feedback_terraform_get.http_method
  type                    = "AWS" #AWS Service Proxy
  passthrough_behavior    = "WHEN_NO_MATCH"
  credentials             = aws_iam_role.apigateway.arn
  integration_http_method = "POST"
  uri                     = "arn:aws:apigateway:us-east-1:dynamodb:action/Scan"

  request_templates = {
    "application/json" = jsonencode(
      {
        TableName = module.dynamodb_table.dynamodb_table_id
        ScanFilter = {
          product = {
            ComparisonOperator = "NOT_NULL"
          }
        }
      }
    )
  }
}

# Define: What status codes to handle from DynamoDB
resource "aws_api_gateway_method_response" "feedback_terraform_get_200" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  resource_id = aws_api_gateway_resource.feedback_terraform.id
  http_method = aws_api_gateway_method.feedback_terraform_get.http_method
  status_code = "200"
}

# Define: What to do with the DynamoDB Response:
resource "aws_api_gateway_integration_response" "feedback_terraform_get_200" {
  depends_on  = [aws_api_gateway_integration.feedback_terraform_get]
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  resource_id = aws_api_gateway_resource.feedback_terraform.id
  http_method = aws_api_gateway_method.feedback_terraform_get.http_method
  status_code = aws_api_gateway_method_response.feedback_terraform_get_200.status_code

  response_templates = {
    "application/json" = <<-EOF
#set($inputRoot = $input.path('$'))
{
  "feedback": [
    #foreach($elem in $inputRoot.Items) {
      #foreach($key in $elem.keySet())
        #set($value = $elem.get($key))
        #set($types = $value.keySet())
        #foreach($type in $types)
          "$key": "$util.escapeJavaScript($value.get($type))"#end#if($foreach.hasNext),#end
      #end
    }#if($foreach.hasNext),#end
    #end
  ]
}
EOF
  }
}

# IAM Permissions
data "aws_iam_policy_document" "apigateway_principal" {
  statement {
    sid    = "1"
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type = "Service"
      identifiers = [
        "apigateway.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "apigateway" {
  name               = "${local.resource_prefix}-sls-apigw"
  assume_role_policy = data.aws_iam_policy_document.apigateway_principal.json
  description        = "An execution role for sls-apigw to execute backend services"
}

resource "aws_iam_role_policy" "allow_dynamo" {
  name   = "${local.resource_prefix}-sls-allow-dynamo"
  policy = data.aws_iam_policy_document.allow_dynamo.json
  role   = aws_iam_role.apigateway.id
}

data "aws_iam_policy_document" "allow_dynamo" {
  statement {
    sid = "AllowDynamo"
    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem",
      "dynamodb:DeleteItem",
      "dynamodb:Query",
      "dynamodb:Scan",
    ]
    resources = [
      module.dynamodb_table.dynamodb_table_arn,
    ]
  }
  statement {
    sid = "Logs"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = ["*"]
  }
}
