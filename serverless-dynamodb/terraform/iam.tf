data "aws_iam_policy_document" "lambda_principal" {
  statement {
    sid    = "1"
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type = "Service"
      identifiers = [
        "lambda.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "lambda" {
  name               = "${local.resource_prefix}-serverless-lambda"
  assume_role_policy = data.aws_iam_policy_document.lambda_principal.json
  description        = "A Lambda execution role for the ${local.resource_prefix}-serverless-lambda function"
}
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "lambda" {
  name   = "${local.resource_prefix}-serverless-lambda"
  policy = data.aws_iam_policy_document.lambda.json
  role   = aws_iam_role.lambda.id
}

data "aws_iam_policy_document" "lambda" {
  statement {
    sid    = "AllowDynamo"
    effect = "Allow"
    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem",
      "dynamodb:DeleteItem",
      "dynamodb:Query",
      "dynamodb:Scan",
    ]
    resources = [
      module.dynamodb_table.this_dynamodb_table_arn
    ]
  }
}
resource "aws_ssm_parameter" "lambda_role_arn" {
  name  = "${local.parameter_prefix}/lambda_role_arn"
  type  = "String"
  value = aws_iam_role.lambda.arn
}
