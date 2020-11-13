module serverless {
  source = "./serverless-support/"
  resource_prefix = local.resource_prefix
  vpc_id = local.vpc_id
}
