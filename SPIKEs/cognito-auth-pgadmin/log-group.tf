resource "aws_cloudwatch_log_group" "pgadmin" {
  name              = "/ecs/${local.service_name}"
  retention_in_days = 5
}
