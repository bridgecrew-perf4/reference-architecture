# Local variables used around the module

locals {
  # Naming
  service_name = "ref-nodejs"
  stage = "test"
  resource_prefix = "${local.stage}-${local.service_name}"
}

provider "aws" {
  region = "us-east-1"
}
