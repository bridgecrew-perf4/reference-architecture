provider "aws" {
  region              = "us-east-1" # TODO: change default region accordingly
  allowed_account_ids = [local.account_ids[terraform.workspace]]
}
terraform {
  required_version = ">= 0.13"
  required_providers {
    aws = {
      source   = "hashicorp/aws"
      versions = "~> 3.0"
    }
  }
  backend "s3" {
    bucket         = "remote-state-bucket-name" # TODO: should match the bucket name created in the bootstrap
    key            = "account.tfstate"
    region         = "us-east-1"               # TODO: This region should match the region your bucket was created in
    dynamodb_table = "remote-state-lock-table" # TODO: should match the lock table name created in the bootstrap
    acl            = "bucket-owner-full-control"
  }
}
