resource "aws_api_gateway_rest_api" "apigw" {
  name        = local.resource_prefix
  description = "${local.resource_prefix} api gateway managed by Terraform"
}
resource "aws_ssm_parameter" "apigw_id" {
  name  = "${local.parameter_prefix}/apigw_id"
  type  = "String"
  value = aws_api_gateway_rest_api.apigw.id
}
resource "aws_ssm_parameter" "apigw_root_resource_id" {
  name  = "${local.parameter_prefix}/apigw_root_resource_id"
  type  = "String"
  value = aws_api_gateway_rest_api.apigw.root_resource_id
}

#resource "aws_api_gateway_domain_name" "apigw" {
#  certificate_arn = local.certificate_arn
#  domain_name     = local.dns_name
#}
#
#resource "aws_api_gateway_base_path_mapping" "apigw" {
#  api_id      = aws_api_gateway_rest_api.apigw.id
#  stage_name  = "prod" #or whatever you call your production serverless stage
#  domain_name = aws_api_gateway_domain_name.apigw.domain_name
#}
