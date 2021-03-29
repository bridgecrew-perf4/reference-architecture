# Bootstrapper Module Documentation
# https://registry.terraform.io/modules/USSBA/bootstrapper/aws/latest
#
# In the following example we are making an assumption that each workspace
# represents a specific account. One account = One workspace.
#
# lower - being the developmental account
# upper - being the production account
#
# We are intentially disregarding the `default` workspace and enforcing the
# use workspaces.
#
# To create the workspaces necessary for this exaple are as followed
# ```
# $ terraform workspace new lower
# $ terraform workspace new upper
# ```
#
# The workspace can be named anything you like, but they must
# match up in the local.accound_ids map.

locals {
  account_ids = {
    lower = "123412341234" # TODO: replace with a real account id
    upper = "567856785678" # TODO: replace with a real account id
  }
}
provider "aws" {
  version = "~> 3.34.0"
  region  = "us-east-1" # TODO: choose your own default region
  allowed_account_ids = [local.account_ids[terraform.workspace]]
}
module "remote_state" {
  source  = "USSBA/bootstrapper/aws"
  version = "1.1.0"
  bucket_name              = "remote-state-bucket-name" # TODO: replace with a bucket name of your choosing
  bucket_source_account_id = local.account_ids["lower"]
  account_ids              = local.account_ids
  lock_table_names         = ["remote-state-lock-table-name"] # TODO: replace with a dynamodb lock table name of your choosing
}