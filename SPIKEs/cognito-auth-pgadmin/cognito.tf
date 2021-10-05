resource "aws_cognito_user_pool" "pool" {
  name = local.pool_name
}
resource "aws_cognito_user_pool_client" "client" {
  name                = "main"
  user_pool_id        = aws_cognito_user_pool.pool.id
  generate_secret     = true
  allowed_oauth_flows = ["code"]
  callback_urls = [
    "https://${local.backend_fqdn}/oauth2/idpresponse",
    "https://${local.frontend_fqdn}",
  ]
  allowed_oauth_scopes                 = ["email", "openid"]
  allowed_oauth_flows_user_pool_client = true
  supported_identity_providers         = ["COGNITO"]
  explicit_auth_flows = [
    "ALLOW_CUSTOM_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_SRP_AUTH",
  ]
}
resource "aws_cognito_user_pool_domain" "domain" {
  # custom domain behind cloudfront
  #domain          = "${local.pool_name}.${local.domain}"
  #certificate_arn = data.aws_acm_certificate.tls.arn

  # or use cognito
  domain       = "ias-demo" # result is https://<domain>.auth.us-east-1.amazoncognito.com/
  user_pool_id = aws_cognito_user_pool.pool.id
}

