resource "aws_db_subnet_group" "rds" {
  name        = local.service_name
  subnet_ids  = aws_subnet.private_subnet.*.id
}
resource "aws_db_instance" "rds" {
  allocated_storage                     = 100
  auto_minor_version_upgrade            = true
  availability_zone                     = aws_subnet.private_subnet[0].availability_zone
  backup_retention_period               = 30
  copy_tags_to_snapshot                 = true
  customer_owned_ip_enabled             = false
  deletion_protection                   = false
  db_subnet_group_name                  = aws_db_subnet_group.rds.name
  engine                                = "postgres"
  engine_version                        = "12.7"
  iam_database_authentication_enabled   = false
  instance_class                        = "db.t3.micro"
  identifier                            = local.service_name
  iops                                  = 0
  multi_az                              = false
  monitoring_interval                   = 0
  option_group_name                     = "default:postgres-12"
  parameter_group_name                  = "default.postgres12"
  performance_insights_enabled          = false
  performance_insights_retention_period = 0
  skip_final_snapshot                   = true
  storage_encrypted                     = false
  storage_type                          = "gp2"
  username                              = "sbaias"
  password                              = "cheeseburger"

  vpc_security_group_ids = [
    aws_security_group.postgres.id,
  ]
}

resource "aws_route53_record" "sbagov_db_record" {
  name            = "pgadmin.${local.domain}"
  allow_overwrite = true
  records         = [aws_db_instance.rds.address]
  ttl             = 120
  type            = "CNAME"
  zone_id         = data.aws_route53_zone.dns.zone_id
}
