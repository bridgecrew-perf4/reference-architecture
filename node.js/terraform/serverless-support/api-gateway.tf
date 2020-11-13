# API Gateway into which the lambda will be deployed
resource "aws_api_gateway_rest_api" "apigw" {
  name        = var.resource_prefix
  description = "${var.resource_prefix} API-GW for Serverless Deployments"
}

resource aws_ssm_parameter apigw_id {
  count = var.export_to_parameter_store ? 1 : 0
  name  = "/${var.resource_prefix}/apigw_id"
  type  = "String"
  value = aws_api_gateway_rest_api.apigw.id
}
resource aws_ssm_parameter apigw_root_resource_id {
  count = var.export_to_parameter_store ? 1 : 0
  name  = "/${var.resource_prefix}/apigw_root_resource_id"
  type  = "String"
  value = aws_api_gateway_rest_api.apigw.root_resource_id
}

