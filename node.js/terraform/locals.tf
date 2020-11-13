# Local variables used around the module

locals {
  # Naming
  service_name = "ref-nodejs"
  environment = "charlestest"
  resource_prefix = "${local.environment}-${local.service_name}"
}

provider "aws" {
  region = "us-east-1"
}
