module "fargate-service" {
  #source = "../../../../terraform-aws-easy-fargate-service/"
  source             = "USSBA/easy-fargate-service/aws"
  version            = "~> 2.3"
  family             = local.resource_prefix
  container_image    = local.container_image
  container_port     = local.container_port
  vpc_id             = local.vpc_id
  public_subnet_ids  = local.public_subnet_ids
  private_subnet_ids = local.private_subnet_ids
  container_environment = [
    { name = "DB_HOST", value = module.aurora.this_rds_cluster_endpoint },
    { name = "DB_USER", value = module.aurora.this_rds_cluster_master_username },
    { name = "DB_NAME", value = module.aurora.this_rds_cluster_database_name },
  ]
  # Lookup these values at container start
  container_secrets = [
    { name = "DB_PASSWORD", valueFrom = aws_ssm_parameter.aurora_password.arn },
  ]

  # CloudFront/DNS stuff
  use_cloudfront  = true
  hosted_zone_id  = "ZFA32P2PPHOAL"
  certificate_arn = "arn:aws:acm:us-east-1:248615503339:certificate/8fd1eb9b-06aa-4ff4-86bb-0d01eb0fdca6"
  service_fqdn    = "${local.resource_prefix}.ussba.io"
}
output "load_balancer_dns" {
  value = module.fargate-service.alb_dns
}
output "fqdn" {
  value = "${local.resource_prefix}.ussba.io"
}
