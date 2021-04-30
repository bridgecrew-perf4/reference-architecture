---
to: terraform/account/principals.tf
---
# allows for roles to be assumed in this account by users in the management account
data "aws_iam_policy_document" "management_principal" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = [local.management_account_id]
    }
    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }
  }
}
