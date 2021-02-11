data "aws_iam_policy_document" "wordpress" {
  statement {
    actions = [
      "ses:*",
    ]
    resources = ["*"]
  }
}
resource "random_password" "rds" {
  length           = 24
  special          = true
  override_special = "_%@"
}
resource "aws_ssm_parameter" "rds_password" {
  name  = "/myapp/myrds/password"
  type  = "SecureString"
  value = random_password.rds.result
}
module "easy-fargate-service" {
  source  = "USSBA/easy-fargate-service/aws"
  version = "3.1.0"

  family                  = "ias-wordpress"
  desired_capacity        = 2
  max_capacity            = 2
  min_capacity            = 2
  task_cpu                = 512
  task_memory             = 2048
  certificate_arn         = "arn:aws:acm:us-east-1:502235151991:certificate/7cd2a913-89c0-487b-8b6d-807286aceb11"
  hosted_zone_id          = "Z099308132XZS0LCPGBAI"
  service_fqdn            = "wordpress.management.ussba.io"
  route53_allow_overwrite = true
  task_policy_json        = data.aws_iam_policy_document.wordpress.json

  efs_configs = [
    {
      container_name = "wordpress"
      file_system_id = aws_efs_file_system.wordpress.id
      root_directory = "/"
      container_path = "/var/www/html"
    },
  ]
  container_definitions = [
    {
      name      = "wordpress"
      image     = "wordpress:latest"
      essential = true
      portMappings = [
        {
          containerPort = 80
        }
      ]
      environment = [
        {
          name  = "WORDPRESS_DB_HOST"
          value = module.rds.this_db_instance_endpoint
        },
        {
          name  = "WORDPRESS_DB_USER"
          value = "iasTeam"
        },
        {
          name  = "WORDPRESS_DB_NAME"
          value = "wordpress"
        },
        {
          name  = "WORDPRESS_CONFIG_EXTRA"
          value = "define('WPOSES_AWS_USE_EC2_IAM_ROLE', true );"
        },
      ]
      secrets = [
        {
          name      = "WORDPRESS_DB_PASSWORD"
          valueFrom = aws_ssm_parameter.rds_password.arn
        }
      ]
    },
  ]
}



data "aws_vpc" "default" {
  default = true
}
data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}



resource "aws_security_group" "efs" {
  description = "ias-wordpress"
  vpc_id      = data.aws_vpc.default.id
  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_security_group_rule" "allow_fargate_into_rds" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.efs.id
  source_security_group_id = module.easy-fargate-service.security_group_id
}
resource "aws_security_group_rule" "allow_fargate_into_efs" {
  type                     = "ingress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  security_group_id        = aws_security_group.efs.id
  source_security_group_id = module.easy-fargate-service.security_group_id
}


resource "aws_efs_file_system" "wordpress" {
  creation_token = "ias-wp-app"
  tags = {
    Name = "ias-wp-app-fargate"
  }
}
resource "aws_efs_mount_target" "wordpress" {
  for_each        = data.aws_subnet_ids.default.ids
  file_system_id  = aws_efs_file_system.wordpress.id
  subnet_id       = each.key
  security_groups = [aws_security_group.efs.id]
}

module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "2.20.0"

  identifier = "ias-wordpress"

  engine               = "mysql"
  family               = "mysql5.7"
  engine_version       = "5.7.19"
  major_engine_version = "5.7"

  instance_class     = "db.t3.micro"
  allocated_storage  = 5
  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  name     = "wordpress"
  username = "iasTeam"
  password = "saltAndPepper"
  port     = "3306"

  subnet_ids             = data.aws_subnet_ids.default.ids
  vpc_security_group_ids = [aws_security_group.efs.id]
}
