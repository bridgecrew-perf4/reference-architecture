provider "aws" {
  region              = "us-east-1"
  allowed_account_ids = ["502235151991"]
  default_tags {
    tags = {
      TerraformSource = "reference-architecture/SPIKEs/aws-waf-captcha"
      ManagedBy       = "terraform"
    }
  }
}
# get the dns name for the ALB and plug it into your browser
# tf state show module.easy-fargate-service.aws_lb.alb | grep dns_name | cut -d '=' -f2 | jq -r
module "easy-fargate-service" {
  source  = "USSBA/easy-fargate-service/aws"
  version = "7.1.0"

  family = "spike-aws-captcha"
  container_definitions = [
    {
      name  = "nginx"
      image = "nginx:latest"
    }
  ]
}

resource "aws_wafv2_web_acl" "regional" {
  description = "spike-aws-captcha"
  name        = "spike-aws-captcha"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "homepage"
    priority = 0

    action {}

    statement {
      # https://github.com/hashicorp/terraform-provider-aws/issues/21754
      # currently not supported by terraform
      # its been over a year
      # CAPTCHA will have to be manually configured for resort back to CloudFormation
      byte_match_statement {
        positional_constraint = "STARTS_WITH"
        search_string         = "/"

        field_to_match {
          uri_path {}
        }

        text_transformation {
          priority = 0
          type     = "NONE"
        }
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "homepage"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "spike-aws-captcha"
    sampled_requests_enabled   = true
  }
}

resource "aws_wafv2_web_acl_association" "alb_assoc" {
  resource_arn = module.easy-fargate-service.alb.arn
  web_acl_arn  = aws_wafv2_web_acl.regional.arn
}
