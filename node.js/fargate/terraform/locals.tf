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

  container_image = "${local.ecr_prefix}/ref-nodejs-fargate:latest"
  container_port  = "8000"

}
## Convenience Variables
locals {
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
