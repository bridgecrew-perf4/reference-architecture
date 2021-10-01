resource "aws_lb" "pgadmin" {
  name               = "${local.pool_name}-pgadmin"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = aws_subnet.public_subnet.*.id
  tags = {
    Name = "${local.pool_name}-pgadmin"
  }
}

resource "aws_route53_record" "default" {
  zone_id         = data.aws_route53_zone.dns.id
  name            = local.backend_fqdn
  allow_overwrite = true
  type            = "A"
  alias {
    name                   = aws_lb.pgadmin.dns_name
    zone_id                = aws_lb.pgadmin.zone_id
    evaluate_target_health = false
  }
}
