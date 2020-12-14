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
  hosted_zone_id  = local.hosted_zone_id
  certificate_arn = local.certificate_arn
  service_fqdn    = local.service_fqdn
}
output "load_balancer_dns" {
  value = module.fargate-service.alb_dns
}
output "fqdn" {
  value = "${local.resource_prefix}.ussba.io"
}
