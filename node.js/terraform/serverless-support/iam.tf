# IAM Permissions for what the function can do

data aws_iam_policy_document lambda_principal {
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


resource aws_iam_role lambda {
  name               = "${var.resource_prefix}-lambda"
  assume_role_policy = data.aws_iam_policy_document.lambda_principal.json
  description        = "A Lambda execution role for the ${var.resource_prefix} function"
}
resource aws_ssm_parameter lambda_role_arn {
  count = var.export_to_parameter_store ? 1 : 0
  type = "String"
  name = "/${var.resource_prefix}/lambda_role_arn"
  value = aws_iam_role.lambda.arn
}

resource aws_ssm_parameter lambda_role_id {
  count = var.export_to_parameter_store ? 1 : 0
  type = "String"
  name = "/${var.resource_prefix}/lambda_role_id"
  value = aws_iam_role.lambda.id
}

resource "aws_iam_role_policy_attachment" "lambda_vpc_execution" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource aws_iam_role_policy lambda {
  count = var.lambda_additional_policy_document_json != "" ? 1 : 0
  name   = "${var.resource_prefix}-lambda"
  policy = var.lambda_additional_policy_document_json
  role   = aws_iam_role.lambda.id
}
