resource "aws_ecs_service" "pgadmin" {
  name                               = local.service_name
  cluster                            = "default"
  task_definition                    = aws_ecs_task_definition.pgadmin.arn
  desired_count                      = 1
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  platform_version                   = "1.4.0"
  launch_type                        = "FARGATE"
  health_check_grace_period_seconds  = 10
  enable_execute_command             = true
  force_new_deployment               = true
  wait_for_steady_state              = true

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  #lifecycle {
  #  ignore_changes = [desired_count]
  #}

  load_balancer {
    target_group_arn = aws_lb_target_group.pgadmin.arn
    container_name   = local.service_name
    container_port   = 80
  }

  network_configuration {
    subnets          = aws_subnet.private_subnet.*.id
    security_groups  = [aws_security_group.pgadmin.id]
    assign_public_ip = false
  }
}
