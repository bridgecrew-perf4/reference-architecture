data "aws_iam_policy_document" "task" {
  statement {
    sid = "exec"
    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel",
      "logs:DescribeLogGroups",
    ]
    resources = ["*"]
  }
  statement {
    sid    = "logging"
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
}
resource "aws_iam_role" "task" {
  name               = "${local.service_name}-task"
  assume_role_policy = data.aws_iam_policy_document.principal.json
}
resource "aws_iam_role_policy" "task" {
  name   = "${local.service_name}-task"
  role   = aws_iam_role.task.id
  policy = data.aws_iam_policy_document.task.json
}
