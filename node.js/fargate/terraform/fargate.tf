module "fargate-service" {
  source          = "USSBA/easy-fargate-service/aws"
  version         = "~> 2.2"
  family          = local.resource_prefix
  container_image = "nginx:latest"
  vpc_id          = local.vpc_id
  public_subnet_ids  = local.public_subnet_ids
}
