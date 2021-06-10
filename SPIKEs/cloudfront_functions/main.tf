## account_id
data "aws_caller_identity" "this" {}

## region name
data "aws_region" "this" {}

## certificate
data "aws_acm_certificate" "this" {
  domain   = "management.ussba.io"
  statuses = ["ISSUED"]
}

## hosted zone
data "aws_route53_zone" "this" {
  name = "management.ussba.io."
}

## locals
locals {
  account_id = data.aws_caller_identity.this.id
  region     = data.aws_region.this.name
}

## bucket
resource "aws_s3_bucket" "web" {
  bucket = "${local.account_id}-ias-demo-${local.region}"
}

## webpages
resource "aws_s3_bucket_object" "index_page" {
  bucket       = aws_s3_bucket.web.bucket
  key          = "index.html"
  source       = "./website/index.html"
  etag         = filemd5("./website/index.html")
  content_type = "text/html"
}
resource "aws_s3_bucket_object" "error_page" {
  bucket       = aws_s3_bucket.web.bucket
  key          = "error.html"
  source       = "./website/error.html"
  etag         = filemd5("./website/error.html")
  content_type = "text/html"
}

## origin access identity
resource "aws_cloudfront_origin_access_identity" "web" {
  comment = "In use by bucket ${aws_s3_bucket.web.bucket}"
}

## bucket policy document
data "aws_iam_policy_document" "bucket_policy" {
  statement {
    actions = ["s3:*"]
    resources = [
      aws_s3_bucket.web.arn,
      "${aws_s3_bucket.web.arn}/*",
    ]
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.web.iam_arn]
    }
  }
}

## bucket policy
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.web.bucket
  policy = data.aws_iam_policy_document.bucket_policy.json
}

# cloudfront functions
resource "aws_cloudfront_function" "hsts" {
  name    = "hsts"
  runtime = "cloudfront-js-1.0" # currently the only valid option
  comment = "hsts"
  publish = true
  code    = file("./functions/strict-transport-security-headers/index.js")
}

# cloudfront
resource "aws_cloudfront_distribution" "web" {
  aliases             = ["www.management.ussba.io"]
  enabled             = true
  is_ipv6_enabled     = true
  comment             = aws_s3_bucket.web.bucket
  default_root_object = "index.html"
  price_class         = "PriceClass_100"
  viewer_certificate {
    cloudfront_default_certificate = false
    acm_certificate_arn            = data.aws_acm_certificate.this.arn
    minimum_protocol_version       = "TLSv1.2_2019"
    ssl_support_method             = "sni-only"
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  origin {
    domain_name = aws_s3_bucket.web.bucket_regional_domain_name
    origin_id   = "web"
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.web.cloudfront_access_identity_path
    }
  }
  default_cache_behavior {
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "web"
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0 #3600
    max_ttl                = 0 #86400
    forwarded_values {
      query_string = false
      headers      = ["Origin"]
      cookies {
        forward = "none"
      }
    }

    ## note `lambda_function_association` (lambda@edge)  may use `viewer-request`, `origin-request`, `origin-response` and `viewer-respose`
    ## note `function_assocation` (cloudfront@functions) may only use `viewer-reqeust` and `viewer-response`

    function_association {
      event_type   = "viewer-response"
      function_arn = aws_cloudfront_function.hsts.arn
    }
  }
}

# dns
resource "aws_route53_record" "web" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = "www.management.ussba.io"
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.web.domain_name
    zone_id                = aws_cloudfront_distribution.web.hosted_zone_id
    evaluate_target_health = false
  }
}
