locals {
  # A name for your application.  Name this in such a way that it doesn't cause naming conflicts
  # with other resources on your AWS acount.
  service_name = "zombo-sls"

  # A name for your environment.  Should be either a variable, terraform workspace, or hardcoded
  environment = terraform.workspace
  #environment = "dev"
  #environment = var.my_env

  resource_prefix = "${local.service_name}-${local.environment}"
  parameter_prefix = "/${local.service_name}/${local.environment}"

  # Convenience variables for region/account_id lookup
  region = data.aws_region.current.name
  account_id = data.aws_caller_identity.current.account_id
}

# Data resources for region/account_id lookup
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
