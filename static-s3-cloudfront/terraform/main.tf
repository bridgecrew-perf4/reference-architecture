locals {
  # Name for your application resources
  app_name = "zombo-app"

  # Target domain name
  domain_name = "zombo.ussba.io"
  # ACM Certificate ARN that matches your domain_name, or wildcard
  acm_certificate_arn = "arn:aws:acm:us-east-1:123412341234:certificate/1234abcd-11aa-2b2b-3c3c-1234abcd1234"
  # Route53 Hosted Zone ID of your target domain
  hosted_zone_id = "ZFA32P2PPHOAL"
}

module "static_site" {
  source  = "USSBA/static-website/aws"
  version = "~> 3.0"

  domain_name         = local.domain_name
  acm_certificate_arn = local.acm_certificate_arn

  # Optional
  hosted_zone_id = local.hosted_zone_id
  #default_subdirectory_object = "index.html"
  hsts_header = "max-age=31536000"
}

# IAM User for automated deployment with GitHub Actions
resource "aws_iam_user" "ci_user" {
  name = "${local.app_name}-ci-user"
}

data "aws_iam_policy_document" "ci_user" {
  statement {
    sid = "S3Bucket"

    actions = [
      "s3:ListBucket",
    ]

    resources = [
      "arn:aws:s3:::${module.static_site.content_bucket_id}",
    ]
  }
  statement {
    sid = "S3Objects"

    actions = [
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:DeleteObject",
    ]

    resources = [
      "arn:aws:s3:::${module.static_site.content_bucket_id}/*",
    ]
  }
}

resource "aws_iam_policy" "ci_user" {
  name   = "${local.app_name}-ci-user"
  path   = "/"
  policy = data.aws_iam_policy_document.ci_user.json
}

resource "aws_iam_user_policy_attachment" "ci_user" {
  user       = aws_iam_user.ci_user.name
  policy_arn = aws_iam_policy.ci_user.arn
}
