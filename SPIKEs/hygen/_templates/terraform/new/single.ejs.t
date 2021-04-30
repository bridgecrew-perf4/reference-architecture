---
to: terraform/bootstrap/single.tf
---
# Bootstrapper Module Documentation
# https://registry.terraform.io/modules/USSBA/bootstrapper/aws/latest
#
# In the following example we are making use of the default namespace.
#
locals {
  account_id = "123412341234"
}
provider "aws" {
  version = "~> 3.34"
  region = "us-east-1" # TODO: choose your own default region
  allowed_account_ids = [local.account_id]
  
}
module "remote_state" {
  source  = "USSBA/bootstrapper/aws"
  version = "1.1.0"
  bucket_name              = "remote-state-bucket-name" # TODO: replace with a bucket name of your choosing
  bucket_source_account_id = local.account_id
  account_ids              = [local.account_id]
  lock_table_names         = ["remote-state-lock-table-name"] # TODO: replace with a dynamodb lock table name of your choosing
}

