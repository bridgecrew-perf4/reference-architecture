resource "aws_lb_target_group" "pgadmin" {
  name_prefix          = local.pool_name
  port                 = 80
  protocol             = "HTTP"
  target_type          = "ip"
  vpc_id               = aws_vpc.vpc.id
  deregistration_delay = 60 # seconds

  lifecycle {
    create_before_destroy = true
  }

  health_check {
    interval            = 30
    path                = "/"
    port                = 80
    protocol            = "HTTP"
    timeout             = 2
    healthy_threshold   = 10
    unhealthy_threshold = 10
    matcher             = "200-399"
  }
}
