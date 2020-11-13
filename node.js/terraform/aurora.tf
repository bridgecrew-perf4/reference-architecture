##
##  Originally Sourced From https://github.com/terraform-aws-modules/terraform-aws-rds-aurora/
###############
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
##     http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.


#############
# RDS Aurora Serverless
#############
module "aurora" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "~> 2.0"

  name                  = "${local.resource_prefix}-aurora-sls"
  engine                = "aurora"
  engine_mode           = "serverless"

  # Replicas?
  replica_scale_enabled = false
  replica_count         = 0

  backtrack_window = 10 # ignored in serverless

  subnets                         = local.subnets
  vpc_id                          = local.vpc_id
  monitoring_interval             = 60
  instance_type                   = "db.r4.large"
  apply_immediately               = true
  skip_final_snapshot             = true
  storage_encrypted               = true
  db_parameter_group_name         = aws_db_parameter_group.aurora_db_postgres96.id
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.aurora_cluster_postgres96.id

  database_name = "mydb"

  scaling_configuration = {
    # NOTE: In production, and possibly staging, you'll want this to not auto-pause
    #       but in dev environments, you'll want to let the database shutdown when
    #       not in use
    auto_pause               = true
    seconds_until_auto_pause = 300

    max_capacity   = 8
    min_capacity   = 1
    timeout_action = "ForceApplyCapacityChange"
  }
}

resource "aws_db_parameter_group" "aurora_db_postgres96" {
  name        = "${local.resource_prefix}-aurora56"
  family      = "aurora5.6"
  description = "${local.resource_prefix}-aurora56"
}

resource "aws_rds_cluster_parameter_group" "aurora_cluster_postgres96" {
  name        = "${local.resource_prefix}-aurora56"
  family      = "aurora5.6"
  description = "${local.resource_prefix}-aurora56"
}

resource "aws_ssm_parameter" "aurora_host" {
  name = "/${local.resource_prefix}/aurora/host"
  type = "String"
  value = module.aurora.this_rds_cluster_endpoint
}
resource "aws_ssm_parameter" "aurora_name" {
  name = "/${local.resource_prefix}/aurora/name"
  type = "String"
  value = module.aurora.this_rds_cluster_database_name
}
resource "aws_ssm_parameter" "aurora_password" {
  name = "/${local.resource_prefix}/aurora/password"
  type = "SecureString"
  value = module.aurora.this_rds_cluster_master_password
}
resource "aws_ssm_parameter" "aurora_user" {
  name = "/${local.resource_prefix}/aurora/user"
  type = "String"
  value = module.aurora.this_rds_cluster_master_username
}

output aurora {
  value = module.aurora
}

############################
# Example of security group
############################
resource "aws_security_group_rule" "db_access" {
  type                     = "ingress"
  from_port                = module.aurora.this_rds_cluster_port
  to_port                  = module.aurora.this_rds_cluster_port
  protocol                 = "tcp"
  source_security_group_id = module.serverless.security_group_id
  security_group_id        = module.aurora.this_security_group_id
}
