#############
# RDS Aurora Serverless v2
#############
module "aurora" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "~> 2.0"

  name        = local.resource_prefix
  engine      = "aurora-mysql"
  engine_mode = "serverless"

  # Serverless v2
  engine_version = "5.7.mysql_aurora.2.07.1"

  ## Replicas must be disabled for serverless
  replica_scale_enabled = false
  replica_count         = 0
  ##backtrack_window = 10 # ignored in serverless

  subnets             = local.private_subnet_ids
  vpc_id              = local.vpc_id
  monitoring_interval = 60
  #instance_type                   = "db.r4.large" # ignored in serverless
  apply_immediately               = local.production_database_config ? false : true
  skip_final_snapshot             = local.production_database_config ? false : true
  storage_encrypted               = true
  db_parameter_group_name         = aws_db_parameter_group.aurora_db_mysql.id
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.aurora_cluster_mysql.id

  database_name = "mydb"

  scaling_configuration = {
    auto_pause               = local.production_database_config ? false : true
    seconds_until_auto_pause = 300
    max_capacity             = 64
    min_capacity             = 1
    timeout_action           = "ForceApplyCapacityChange"
  }

  copy_tags_to_snapshot = true
}

resource "aws_db_parameter_group" "aurora_db_mysql" {
  name        = "${local.resource_prefix}-aurora57"
  family      = "aurora-mysql5.7"
  description = "${local.resource_prefix}-aurora57"
}

resource "aws_rds_cluster_parameter_group" "aurora_cluster_mysql" {
  name        = "${local.resource_prefix}-aurora57"
  family      = "aurora-mysql5.7"
  description = "${local.resource_prefix}-aurora57"
}

resource "aws_ssm_parameter" "aurora_host" {
  name  = "/${local.resource_prefix}/aurora/host"
  type  = "String"
  value = module.aurora.this_rds_cluster_endpoint
}
resource "aws_ssm_parameter" "aurora_name" {
  name  = "/${local.resource_prefix}/aurora/name"
  type  = "String"
  value = module.aurora.this_rds_cluster_database_name
}
resource "aws_ssm_parameter" "aurora_password" {
  name      = "/${local.resource_prefix}/aurora/password"
  type      = "SecureString"
  value     = module.aurora.this_rds_cluster_master_password
  overwrite = true
}
resource "aws_ssm_parameter" "aurora_user" {
  name  = "/${local.resource_prefix}/aurora/user"
  type  = "String"
  value = module.aurora.this_rds_cluster_master_username
}

############################
# Example of security group
############################
resource "aws_security_group_rule" "db_access" {
  type                     = "ingress"
  from_port                = module.aurora.this_rds_cluster_port
  to_port                  = module.aurora.this_rds_cluster_port
  protocol                 = "tcp"
  source_security_group_id = module.fargate-service.security_group_id
  security_group_id        = module.aurora.this_security_group_id
}
