resource "aws_security_group" "alb" {
  name   = "${local.pool_name}-alb"
  vpc_id = aws_vpc.vpc.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = 6
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = 6
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "pgadmin" {
  name   = "${local.pool_name}-pgadmin"
  vpc_id = aws_vpc.vpc.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = 6
    security_groups = [aws_security_group.alb.id]
  }
}

resource "aws_security_group" "postgres" {
  name   = "${local.pool_name}-postgres"
  vpc_id = aws_vpc.vpc.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = 6
    security_groups = [aws_security_group.pgadmin.id]
  }
}
