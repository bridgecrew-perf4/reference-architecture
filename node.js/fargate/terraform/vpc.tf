# Default VPCs

## Configuration Locals
locals {
  # Generally recommended to make these different for each VPC
  # It makes IP tracing a little easier at times
  cidr_block = "10.99.0.0/16"
}
##
##  Option 1: Use the Default VPC. Generally not recommended for databases.
##
## Fetch Default VPC info
#data "aws_vpc" "default" {
#  default = true
#}
#
#data "aws_subnet_ids" "default" {
#  vpc_id = data.aws_vpc.default.id
#}


##
##  Option 2: Create a dedicated VPC
##

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2.64"

  name = local.resource_prefix

  azs = ["us-east-1a", "us-east-1b", "us-east-1c"]

  cidr = local.cidr_block
  # Calculate the subnet cidrs using the vpc cidr
  private_subnets = [cidrsubnet(local.cidr_block, 8, 128), cidrsubnet(local.cidr_block, 8, 129), cidrsubnet(local.cidr_block, 8, 130)]
  public_subnets  = [cidrsubnet(local.cidr_block, 8, 0), cidrsubnet(local.cidr_block, 8, 1), cidrsubnet(local.cidr_block, 8, 2)]

  enable_ipv6 = true

  enable_nat_gateway     = true
  single_nat_gateway     = local.production_vpc_config ? false : true
  one_nat_gateway_per_az = local.production_vpc_config ? true : false

  #  public_subnet_tags = {
  #    Name = "overridden-name-public"
  #  }
  #
  #  tags = {
  #    Owner       = "user"
  #    Environment = "dev"
  #  }
  #
  #  vpc_tags = {
  #    Name = "vpc-name"
  #  }
}


## Output Locals
##   They function the same, but are broken out to indicate "stuff not used by this file"
##   You _could_ just use the direct outputs from the module/resources, but this makes
##   it easier to switch your VPC source without changing the inputs for all your other resources
locals {
  # VPC
  ## Default VPC
  #vpc_id  = data.aws_vpc.default.id
  #public_subnets = data.aws_subnet_ids.default.ids

  ## VPC Module
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnets
  private_subnet_ids = module.vpc.private_subnets
}
