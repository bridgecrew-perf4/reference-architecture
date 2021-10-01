data "aws_region" "current" {}

data "aws_route53_zone" "dns" {
  name = local.domain
}

data "aws_acm_certificate" "tls" {
  domain   = local.domain
  statuses = ["ISSUED"]
}

locals {
  #common
  region = data.aws_region.current.name

  #vpc
  zone_map                   = { 0 = "a", 1 = "b" }
  cidr_block                 = "10.20.0.0/16"
  cidr_public_subnet_blocks  = ["10.20.0.0/24", "10.20.1.0/24"]
  cidr_private_subnet_blocks = ["10.20.10.0/24", "10.20.11.0/24"]
  ipv4_acl_ingress_rules     = [{ rule_number = 1000, action = "allow", protocol = -1, from_port = 0, to_port = 65535, cidr_block = "0.0.0.0/0" }]
  ipv4_acl_egress_rules      = [{ rule_number = 2000, action = "allow", protocol = -1, from_port = 0, to_port = 65535, cidr_block = "0.0.0.0/0" }]
  is_single_nat_gateway      = true

  #cognito
  pool_name        = "ias"
  domain           = "management.ussba.io"
  backend_fqdn     = "alb.${local.domain}"
  frontend_fqdn    = "cloudfront.${local.domain}"
  service_name     = "pgadmin"
  container_name   = "main"
  pgadmin_email    = "sbaias@fearless.tech"
  pgadmin_password = "cheeseburger"
}

