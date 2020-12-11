# Local variables used around the module

locals {
  # Naming
  service_name    = "ref-nodejs-fargate"
  stage           = "test"
  resource_prefix = "${local.stage}-${local.service_name}"

  # Aurora RDS Serverless Database Config
  production_database_config = false
  production_vpc_config = false
}

provider "aws" {
  region = "us-east-1"
}
