variable "image_identifier" {
  description = "ecr url and image tag. example, url:tag"
}

resource "aws_apprunner_service" "example" {
  service_name = "example"

  source_configuration {

    authentication_configuration {
      access_role_arn = aws_iam_role.role.arn
    }

    image_repository {
      image_configuration {
        port = "80"
      }
      image_identifier      = var.image_identifier
      image_repository_type = "ECR"
    }
  }
}

resource "aws_iam_role" "role" {
  name = "AppRunnerRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "build.apprunner.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "policy" {
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:DescribeImages",
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_policy_attachment" "attachment" {
  name       = "policy-attachment"
  roles      = [aws_iam_role.role.name]
  policy_arn = aws_iam_policy.policy.arn
}
