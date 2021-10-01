data "aws_iam_policy_document" "exec" {
  statement {
    sid    = "required"
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
}
resource "aws_iam_role" "exec" {
  name               = "${local.service_name}-exec"
  assume_role_policy = data.aws_iam_policy_document.principal.json
}
resource "aws_iam_role_policy" "exec" {
  name   = "${local.service_name}-exec"
  role   = aws_iam_role.exec.id
  policy = data.aws_iam_policy_document.exec.json
}
