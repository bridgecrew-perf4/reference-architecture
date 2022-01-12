data "archive_file" "zip_lambda" {
  # If null_resource does not run create_pkg.sh
  # these folders / files will not exist.
  type        = "zip"
  source_dir  = "${path.module}/function"
  output_path = "${path.module}/lambda_function_payload.zip"
}

resource "aws_lambda_permission" "example" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.example.arn
  principal     = "config.amazonaws.com"
  statement_id  = "AllowExecutionFromConfig"
}

resource "aws_config_config_rule" "example" {
  name = "spike-config-rule"
  description = "monitors security groups for compliance"

  scope {
    compliance_resource_types = ["AWS::EC2:SecurityGroup"]
  }

  source {
    owner             = "CUSTOM_LAMBDA"
    source_identifier = aws_lambda_function.example.arn
    source_detail {
      message_type = "ConfigurationItemChangeNotification"
    }
  }

  depends_on = [
    aws_lambda_permission.example,
  ]
}

resource "aws_iam_role" "example" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "example" {
  statement {
    sid = "1"

    actions = [
      "ec2:*",
      "logs:*",
      "config:*"
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "example" {
  name        = "iam_for_lambda"
  path        = "/"
  policy      = data.aws_iam_policy_document.example.json
}

resource "aws_iam_role_policy_attachment" "example" {
  role       = aws_iam_role.example.name
  policy_arn = aws_iam_policy.example.arn
}

resource "aws_lambda_function" "example" {
  filename      = "lambda_function_payload.zip"
  function_name = "lambda_function_name"
  role          = aws_iam_role.example.arn
  handler       = "index.lambda_handler"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  #source_code_hash = filebase64sha256("lambda_function_payload.zip")

  runtime = "python3.9"
}
