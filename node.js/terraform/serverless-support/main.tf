locals {
  # VPC
  vpc_id = var.vpc_id == "" ? data.aws_vpc.default[0].id : var.vpc_id
  subnets = var.subnet_ids == [] ? data.aws_subnet_ids.default[0].ids : var.subnet_ids
}

data "aws_vpc" "default" {
  count = var.vpc_id == "" ? 1 : 0
  default = true
}

data "aws_subnet_ids" "default" {
  count = var.subnet_ids == [] ? 1 : 0
  vpc_id = local.vpc_id
}
