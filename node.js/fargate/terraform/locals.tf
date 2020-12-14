# Local variables used around the module

## Configuration
locals {
  # Naming
  service_name    = "ref-nodejs-fargate"
  stage           = "test"
  resource_prefix = "${local.stage}-${local.service_name}"

  # Aurora RDS Serverless Database Config
  production_database_config = false
  production_vpc_config      = false

  container_name = "ref-nodejs-fargate"
  container_tag  = "latest"
  container_port = "8000"

  # DNS Configuration
  hosted_zone_id  = "ZFA32P2PPHOAL"
  certificate_arn = "arn:aws:acm:us-east-1:248615503339:certificate/8fd1eb9b-06aa-4ff4-86bb-0d01eb0fdca6"
  service_fqdn    = "${local.resource_prefix}.ussba.io"
}

## Convenience Variables
locals {
  container_image        = "${local.ecr_prefix}/${local.container_name}:${local.container_tag}"
  parameter_store_prefix = "arn:aws:ssm:${local.region}:${local.account_id}:parameter"
  ecr_prefix             = "${local.account_id}.dkr.ecr.${local.region}.amazonaws.com"
  account_id             = data.aws_caller_identity.current.account_id
  region                 = data.aws_region.current.name
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

provider "aws" {
  region = "us-east-1"
}
