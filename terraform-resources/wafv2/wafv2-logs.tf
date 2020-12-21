## WAF Logging
##  These resources are everything WAFv2 needs to start logging
##  The actual connection to these resources is created in the respective ACL files

## S3 Bucket for Logs
resource "aws_s3_bucket" "waf_logs" {
  bucket = local.waf_bucket_name
  acl    = "private"
}

data "aws_iam_policy_document" "waf_firehose_policy" {
  statement {
    sid = "SendStreamToBucket"
    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject",
      "s3:PutObjectAcl",
    ]
    resources = [
      aws_s3_bucket.waf_logs.arn,
      "${aws_s3_bucket.waf_logs.arn}/${local.waf_log_bucket_prefix_cloudfront}*",
      "${aws_s3_bucket.waf_logs.arn}/${local.waf_log_bucket_prefix_regional}*",
    ]
  }
  statement {
    sid = "UseTheStream"
    actions = [
      "kinesis:DescribeStream",
      "kinesis:GetShardIterator",
      "kinesis:GetRecords",
    ]
    resources = [
      aws_kinesis_firehose_delivery_stream.waf_log_stream_cloudfront.arn,
      aws_kinesis_firehose_delivery_stream.waf_log_stream_regional.arn,
    ]
  }
}
data "aws_iam_policy_document" "waf_firehose_principal" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type = "Service"
      identifiers = [
        "firehose.amazonaws.com"
      ]
    }
    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values = [
        local.account_id
      ]
    }
  }
}
resource "aws_iam_role" "waf_firehose_role" {
  name               = "${local.waf_prefix}_waf_firehose_role"
  assume_role_policy = data.aws_iam_policy_document.waf_firehose_principal.json
}
resource "aws_iam_role_policy" "waf_firehose" {
  name   = "${local.waf_prefix}-waf-firehose-policy"
  role   = aws_iam_role.waf_firehose_role.id
  policy = data.aws_iam_policy_document.waf_firehose_policy.json
}
resource "aws_kinesis_firehose_delivery_stream" "waf_log_stream_cloudfront" {
  name        = "aws-waf-logs-${local.waf_cloudfront_prefix}"
  destination = "s3"

  s3_configuration {
    role_arn           = aws_iam_role.waf_firehose_role.arn
    bucket_arn         = aws_s3_bucket.waf_logs.arn
    compression_format = local.waf_log_compression_format
    prefix             = local.waf_log_bucket_prefix_cloudfront
  }
}
resource "aws_kinesis_firehose_delivery_stream" "waf_log_stream_regional" {
  name        = "aws-waf-logs-${local.waf_regional_prefix}"
  destination = "s3"

  s3_configuration {
    role_arn           = aws_iam_role.waf_firehose_role.arn
    bucket_arn         = aws_s3_bucket.waf_logs.arn
    compression_format = local.waf_log_compression_format
    prefix             = local.waf_log_bucket_prefix_regional
  }
}


