data "aws_caller_identity" "current" {}

locals {
  app_name = "zombo-app"
}

module "static_site" {
  source = "USSBA/static-website/aws"
  version = "~> 2.0"

  domain_name = "${local.app_name}.ussba.io"
  acm_certificate_arn = "arn:aws:acm:us-east-1:248615503339:certificate/8fd1eb9b-06aa-4ff4-86bb-0d01eb0fdca6"

  # Optional
  hosted_zone_id = "ZFA32P2PPHOAL"
  #default_subdirectory_object = "index.html"
  hsts_header = "max-age=31536000"
}
