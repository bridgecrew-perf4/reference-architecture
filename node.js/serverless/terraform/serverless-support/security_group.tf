resource "aws_security_group" "lambda" {
  name        = "${var.resource_prefix}-lambda"
  description = "Security group for ${var.resource_prefix}"
  vpc_id      = local.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_ssm_parameter" "lambda_security_group" {
  count = var.export_to_parameter_store ? 1 : 0
  type = "String"
  name = "/${var.resource_prefix}/lambda_security_group_id"
  value = aws_security_group.lambda.id
}
