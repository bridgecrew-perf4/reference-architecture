resource "aws_ecs_task_definition" "pgadmin" {
  family                   = local.service_name
  execution_role_arn       = aws_iam_role.exec.arn
  task_role_arn            = aws_iam_role.task.arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu       = 256
  memory    = 512
  container_definitions = jsonencode([
    {
      name      = local.service_name
      image     = "dpage/pgadmin4"
      essential = true
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.pgadmin.name
          awslogs-region        = local.region
          awslogs-stream-prefix = local.service_name
        }
      }
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
      environment = [
        { name = "PGADMIN_DEFAULT_EMAIL", value = local.pgadmin_email },
        { name = "PGADMIN_DEFAULT_PASSWORD", value = local.pgadmin_password },
        #{ name = "PGADMIN_DISABLE_POSTFIX", value = "not-null" },   # if not-null postfix will be disabled
        #{ name = "PGADMIN_ENABLE_TLS", value = "not-null" }         # if not-null required certificate and key
        #{ name = "PGADMIN_LISTEN_ADDRESS", value = "0.0.0.0" },     # default should work in most cases but may beed to be set to 0.0.0.0
        #{ name = "PGADMIN_LISTEN_PORT", value = "80" },             # default is 80 or 443 when TLS is enabled
        #{ name = "PGADMIN_SERVER_JSON_FILE", value = ""},           # default is /pgadmin4/servers.json
        #{ name = "GUNICORN_ACCESS_LOGFILE", value = "dont-know" },  # default is stdout
        #{ name = "GUNICORN_THREADS", value = "25" },                # default is 25
        #{ name = "PGADMIN_CONFIG_<name>", value = "value"},         # https://www.pgadmin.org/docs/pgadmin4/latest/config_py.html#config-py
        #{ name = "PGADMIN_CONFIG_LOGIN_BANNER", value = "<h4>IAS Authorised Users Only!</h4> Unauthorised use is strictly forbidden." },
        #{ name = "PGADMIN_CONFIG_MAIL_SERVER", value = "" },        # default is localhost
        #{ name = "PGADMIN_CONFIG_MAIL_PORT", value = "" },          # default is 25
        #{ name = "PGADMIN_CONFIG_MAIL_USE_SSL", value = "" },       # default is False
        #{ name = "PGADMIN_CONFIG_MAIL_USE_TLS", value = "" },       # default is False
        #{ name = "PGADMIN_CONFIG_MAIL_USERNAME", value = "" },      # default is empty string
        #{ name = "PGADMIN_CONFIG_MAIL_PASSWORD", value = "" },      # default is empty string
      ]
    },
  ])
}

