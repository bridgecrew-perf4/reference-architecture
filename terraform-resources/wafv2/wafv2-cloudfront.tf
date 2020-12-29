resource "aws_wafv2_web_acl" "waf_cloudfront" {
  name        = local.waf_cloudfront_prefix
  description = "${local.waf_cloudfront_prefix} CloudFront Terraform managed WAF with generic rules"
  scope       = "CLOUDFRONT"

  default_action {
    allow {}
  }

  # AWS Common Rule Set
  #  The Core rule set (CRS) rule group contains rules that are generally applicable to web applications. This provides protection against exploitation of a wide range of vulnerabilities, including high risk and commonly occurring vulnerabilities described in OWASP publications. Consider using this rule group for any AWS WAF use case. 
  #  https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-list.html
  rule {
    name     = "aws-crs"
    priority = 1

    override_action {
      ## To switch to "count" instead of "none", uncomment the following
      #count {}
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"

        # The for_each array is a list of every rule you want turned off
        # See AWS docs for the rule name: https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-list.html
        dynamic "excluded_rule" {
          for_each = []
          #for_each = ["NoUserAgent_HEADER"]

          iterator = rule
          content {
            name = rule.value
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${local.waf_cloudfront_prefix}-aws-crs"
      sampled_requests_enabled   = false
    }
  }

  # SQL Injection.  Only useful if an application uses a SQL database somewhere behind the scenes.
  #   Comment out the whole block if you don't need it
  rule {
    name     = "aws-sqli"
    priority = 2
    override_action {
      #count {}
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesSQLiRuleSet"
        vendor_name = "AWS"
        # The for_each array is a list of every rule you want turned off
        # See AWS docs for the rule name: https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-list.html
        dynamic "excluded_rule" {
          for_each = []
          #for_each = ["SQLi_URIPATH"]

          iterator = rule
          content {
            name = rule.value
          }
        }
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${local.waf_cloudfront_prefix}-aws-sqli"
      sampled_requests_enabled   = false
    }
  }

  # Linux File Inclusion.  The Linux operating system rule group contains rules that block request patterns associated with the exploitation of vulnerabilities specific to Linux, including Linux-specific Local File Inclusion (LFI) attacks. This can help prevent attacks that expose file contents or run code for which the attacker should not have had access. You should evaluate this rule group if any part of your application runs on Linux.
  rule {
    name     = "aws-lfi"
    priority = 3
    override_action {
      #count {}
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesLinuxRuleSet"
        vendor_name = "AWS"
        # The for_each array is a list of every rule you want turned off
        # See AWS docs for the rule name: https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-list.html
        dynamic "excluded_rule" {
          for_each = []
          #for_each = ["LFI_QUERYARGUMENTS"]

          iterator = rule
          content {
            name = rule.value
          }
        }
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${local.waf_cloudfront_prefix}-aws-lfi"
      sampled_requests_enabled   = false
    }
  }

  # The POSIX operating system rule group contains rules that block request patterns associated with the exploitation of vulnerabilities specific to POSIX and POSIX-like operating systems, including Local File Inclusion (LFI) attacks. This can help prevent attacks that expose file contents or run code for which the attacker should not have had access. You should evaluate this rule group if any part of your application runs on a POSIX or POSIX-like operating system, including Linux, AIX, HP-UX, macOS, Solaris, FreeBSD, and OpenBSD.
  rule {
    name     = "aws-linux-shell"
    priority = 4
    override_action {
      #count {}
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesUnixRuleSet"
        vendor_name = "AWS"
        # The for_each array is a list of every rule you want turned off
        # See AWS docs for the rule name: https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-list.html
        dynamic "excluded_rule" {
          for_each = []
          #for_each = ["UNIXShellCommandsVariables_QUERYARGUMENTS"]

          iterator = rule
          content {
            name = rule.value
          }
        }
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${local.waf_cloudfront_prefix}-aws-linux-shell"
      sampled_requests_enabled   = false
    }
  }

  ## The Windows operating system rule group contains rules that block request patterns associated with the exploitation of vulnerabilities specific to Windows, like remote execution of PowerShell commands. This can help prevent exploitation of vulnerabilities that allow an attacker to run unauthorized commands or run malicious code. Evaluate this rule group if any part of your application runs on a Windows operating system. 
  ##
  ## ENABLE IF: You have any windows systems running
  ##
  #rule {
  #  name     = "aws-powershell"
  #  priority = 5
  #  override_action {
  #    #count {}
  #    none {}
  #  }
  #  statement {
  #    managed_rule_group_statement {
  #      name        = "AWSManagedRulesWindowsRuleSet"
  #      vendor_name = "AWS"
  #      # The for_each array is a list of every rule you want turned off
  #      # See AWS docs for the rule name: https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-list.html
  #      dynamic "excluded_rule" {
  #        for_each = []
  #        #for_each = ["PowerShellCommands_Set1_QUERYARGUMENTS"]
  #
  #        iterator = rule
  #        content {
  #          name = rule.value
  #        }
  #      }
  #    }
  #  }
  #  visibility_config {
  #    cloudwatch_metrics_enabled = true
  #    metric_name                = "${local.waf_cloudfront_prefix}-aws-powershell"
  #    sampled_requests_enabled   = false
  #  }
  #}

  ## PHP.  The PHP application rule group contains rules that block request patterns associated with the exploitation of vulnerabilities specific to the use of the PHP programming language, including injection of unsafe PHP functions. This can help prevent exploitation of vulnerabilities that allow an attacker to remotely run code or commands for which they are not authorized. Evaluate this rule group if PHP is installed on any server with which your application interfaces. 
  ##
  ## ENABLE IF: You have any PHP running in your account (WordPress, Drupal, etc)
  ##
  #rule {
  #  name     = "aws-php"
  #  priority = 6
  #  override_action {
  #    #count {}
  #    none {}
  #  }
  #  statement {
  #    managed_rule_group_statement {
  #      name        = "AWSManagedRulesPHPRuleSet"
  #      vendor_name = "AWS"
  #      # The for_each array is a list of every rule you want turned off
  #      # See AWS docs for the rule name: https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-list.html
  #      dynamic "excluded_rule" {
  #        for_each = []
  #        #for_each = ["PHPHighRiskMethodsVariables_QUERYARGUMENTS"]
  #
  #        iterator = rule
  #        content {
  #          name = rule.value
  #        }
  #      }
  #    }
  #  }
  #  visibility_config {
  #    cloudwatch_metrics_enabled = true
  #    metric_name                = "${local.waf_cloudfront_prefix}-aws-php"
  #    sampled_requests_enabled   = false
  #  }
  #}

  ## WordPress.  The WordPress application rule group contains rules that block request patterns associated with the exploitation of vulnerabilities specific to WordPress sites. You should evaluate this rule group if you are running WordPress. This rule group should be used in conjunction with the SQL database and PHP application rule groups.
  ##
  ## ENABLE IF: You have any WordPress running in your account
  ##
  #rule {
  #  name     = "aws-wordpress"
  #  priority = 7
  #  override_action {
  #    #count {}
  #    none {}
  #  }
  #  statement {
  #    managed_rule_group_statement {
  #      name        = "AWSManagedRulesWordPressRuleSet"
  #      vendor_name = "AWS"
  #      # The for_each array is a list of every rule you want turned off
  #      # See AWS docs for the rule name: https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-list.html
  #      dynamic "excluded_rule" {
  #        for_each = []
  #        #for_each = ["WordPressExploitableCommands_QUERYSTRING"]
  #
  #        iterator = rule
  #        content {
  #          name = rule.value
  #        }
  #      }
  #    }
  #  }
  #  visibility_config {
  #    cloudwatch_metrics_enabled = true
  #    metric_name                = "${local.waf_cloudfront_prefix}-aws-wordpress"
  #    sampled_requests_enabled   = false
  #  }
  #}

  ## IP Reputation.  IP reputation rule groups allow you to block requests based on their source. Choose one or more of these rule groups if you want to reduce your exposure to bot traffic or exploitation attempts, or if you are enforcing geographic restrictions on your content.
  ##
  rule {
    name     = "aws-ip-reputation"
    priority = 8
    override_action {
      #count {}
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
        # Only 1 rule, so no reason to exclude
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${local.waf_cloudfront_prefix}-aws-ip-reputation"
      sampled_requests_enabled   = false
    }
  }

  ## Anonymous IP Blocking. The Anonymous IP list rule group contains rules to block requests from services that allow the obfuscation of viewer identity. These include requests from VPNs, proxies, Tor nodes, and hosting providers (including AWS). This rule group is useful if you want to filter out viewers that might be trying to hide their identity from your application. Blocking the IP addresses of these services can help mitigate bots and evasion of geographic restrictions. 
  ##
  ## ENABLE IF: You have serious concerns about being spammed by "fake" users.  This rule is somewhat risky, in that your own applications talking to each other could be subjected to these rules and blocked
  ##
  #rule {
  #  name     = "aws-ip-anonymous"
  #  priority = 8
  #  override_action {
  #    #count {}
  #    none {}
  #  }
  #  statement {
  #    managed_rule_group_statement {
  #      name        = "AWSManagedRulesAnonymousIpList"
  #      vendor_name = "AWS"
  #    }
  #  }
  #  visibility_config {
  #    cloudwatch_metrics_enabled = true
  #    metric_name                = "${local.waf_cloudfront_prefix}-aws-ip-anonymous"
  #    sampled_requests_enabled   = false
  #  }
  #}
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name = "${local.waf_cloudfront_prefix}-waf"
    sampled_requests_enabled   = false
  }
}

resource "aws_wafv2_web_acl_logging_configuration" "waf_cloudfront" {
  log_destination_configs = [aws_kinesis_firehose_delivery_stream.waf_log_stream_cloudfront.arn]
  resource_arn            = aws_wafv2_web_acl.waf_cloudfront.arn

  ## See Terraform docs for how to exclude certain fields from logging
  ##   https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_logging_configuration
  #redacted_fields {
  #  single_header {
  #    name = "user-agent"
  #  }
  #}
}

