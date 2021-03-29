data "aws_region" "this" {}
data "aws_caller_identity" "this" {}

locals {
  account_id = data.aws_caller_identity.this.account_id
  region     = data.aws_region.this.name
  acls = {
    all       = { rule_action = "allow", protocol = "-1", from_port = 0, to_port = 0, cidr_block = "0.0.0.0/0" }
    http      = { rule_action = "allow", protocol = "6", from_port = 80, to_port = 80, cidr_block = "0.0.0.0/0" }
    https     = { rule_action = "allow", protocol = "6", from_port = 443, to_port = 443, cidr_block = "0.0.0.0/0" }
    ntp       = { rule_action = "allow", protocol = "17", from_port = 123, to_port = 123, cidr_block = "0.0.0.0/0" }
    smtp      = { rule_action = "allow", protocol = "6", from_port = 587, to_port = 587, cidr_block = "0.0.0.0/0" }
    ephemeral = { rule_action = "allow", protocol = "6", from_port = 1024, to_port = 65535, cidr_block = "0.0.0.0/0" }
  }
  # map used to generate availability zones and subnets
  zone_map = { a = 0, b = 1 }
  settings = {
    default = {
      name  = "${terraform.workspace}-application"
      zones = formatlist("%s%s", local.region, keys(local.zone_map)) # result: ["us-east-1a", "us-east-1b"]
    }
    dev = {
      account_id         = "123412341234"
      single_nat_gateway = true
      cidr               = "10.250.0.0/16"
    }
    stg = {
      account_id         = "123412341234"
      single_nat_gateway = true
      cidr               = "10.251.0.0/16"
    }
    prd = {
      account_id         = "567856785678"
      single_nat_gateway = false
      cidr               = "10.252.0.0/16"
    }
  }

  # environment
  env = merge(local.ckan.default, local.ckan[terraform.workspace])

  # subnet calculations
  public_subnet_cidr_blocks  = [for n in toset(values(local.zone_map)) : cidrsubnet(local.env.cidr, 8, tonumber(n))] # result: ["10.250.0.0/24", "10.250.1.0/24"]
  private_subnet_cidr_blocks = [for n in toset(values(local.zone_map)) : cidrsubnet(local.env.cidr, 8, tonumber(n) + 128)] # result: ["10.250.128.0/24", "10.250.129.0/24"]
}
