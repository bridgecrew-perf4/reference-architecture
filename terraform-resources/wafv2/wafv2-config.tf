locals {
  # Configure this with any name that makes sense for you
  waf_prefix = "basic-waf"
  account_id = data.aws_caller_identity.current.account_id
  waf_bucket_name = "${local.account_id}-waf-logs"
}

# This may already exist elsewhere in your code
data "aws_caller_identity" "current" {}

locals {
  ## Convenience variables
  waf_cloudfront_prefix = "${local.waf_prefix}-cloudfront"
  waf_regional_prefix = "${local.waf_prefix}-regional"

  ## Config you probably don't need to change
  waf_log_compression_format = "GZIP"
  waf_log_bucket_prefix_regional = "regional/"
  waf_log_bucket_prefix_cloudfront = "cloudfront/"
}

