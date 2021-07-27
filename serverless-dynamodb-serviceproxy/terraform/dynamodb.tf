module "dynamodb_table" {
  source  = "terraform-aws-modules/dynamodb-table/aws"
  version = "~> 1.1.0"

  name     = "${local.resource_prefix}-table"
  hash_key = "dd_item_id"
  #range_key = "sort"

  attributes = [
    {
      name = "dd_item_id"
      type = "S"
    },
    {
      name = "timestamp"
      type = "N"
    },
    {
      name = "product"
      type = "S"
    }
  ]

  global_secondary_indexes = [
    {
      name               = "TimestampIndex"
      hash_key           = "product"
      range_key          = "timestamp"
      projection_type    = "INCLUDE"
      non_key_attributes = ["id"]
    }
  ]

  tags = {
    Terraform   = "true"
    Environment = local.environment
  }
}

#module "dynamodb_table_advanced" {
#  source  = "terraform-aws-modules/dynamodb-table/aws"
#  version = "~> 1.1.0"
#
#  name     = "${local.resource_prefix}-table-advanced"
#  hash_key = "dd_item_id"
#  #range_key = "not-used"
#
#  attributes = [
#    {
#      name = "dd_item_id"
#      type = "S"
#    },
#    {
#      name = "timestamp"
#      type = "N"
#    }
#    {
#      name = "product"
#      type = "S"
#    }
#  ]
#
#  global_secondary_indexes = [
#    {
#      name               = "TimestampIndex"
#      hash_key           = "product"
#      range_key          = "timestamp"
#      projection_type    = "INCLUDE"
#      non_key_attributes = ["id"]
#    }
#  ]
#
#  tags = {
#    Terraform   = "true"
#    Environment = local.environment
#  }
#}
