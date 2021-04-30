---
to: terraform/account/ca-admin.tf
---
# ca-admin role
resource "aws_iam_role" "ca_admin" {
  name               = "ca-admin"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.management_principal.json
}

# attach the ca-admin inline policy to the role
resource "aws_iam_role_policy" "ca_admin" {
  name   = "ca-admin"
  role   = aws_iam_role.ca_admin.id
  policy = data.aws_iam_policy_document.ca_admin.json
}

# inline policy for the ca-admin role
data "aws_iam_policy_document" "ca_admin" {
  statement {
    effect    = "Allow"
    actions   = ["*"]
    resources = ["*"]
  }
}

