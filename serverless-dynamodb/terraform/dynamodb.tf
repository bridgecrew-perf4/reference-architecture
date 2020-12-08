module "dynamodb_table" {
  source   = "terraform-aws-modules/dynamodb-table/aws"
  version  = "~> 0.10.0"

  name      = "${local.resource_prefix}-table"
  hash_key  = "ip"
  range_key = "path"

  attributes = [
    {
      name = "ip"
      type = "S"
    },
    {
      name = "path"
      type = "S"
    }
  ]

  tags = {
    Terraform   = "true"
    Environment = local.environment
  }
}
