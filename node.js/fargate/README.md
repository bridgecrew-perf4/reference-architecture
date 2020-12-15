# Node.js with Fargate Reference Architecture

The goal of this project is to provide a sample configuration for creating an ECS Fargate deployment of node.js, with persistent infrastructure managed by Terraform.

## Features

* Node.js deployed to Fargate
* Terraform managing:
  * RDS
  * Security Groups
  * IAM Permissions
  * API Gateway top-level resource
  * Secrets and other parameters using AWS Parameter Store
  * ECS Fargate configuration
* Container build and push managed by script

## Prerequisites

* node.js
* nvm (optional)
* AWS credentials available to your shell
* Terraform 0.13+
* AWS Resources for DNS
  * Route53 Hosted Zone (For something like `example.com`)
  * ACM Certificate with a wildcard hostname (ex. `*.example.com`)
  * Alternately, comment out the "CloudFront/DNS stuff" section in `fargate.tf`

## Deployment Process

### Docker

```shell
# Before running: Ensure AWS credentials are configured

# Build the Docker image and push to Amazon ECR
# ./build-docker-and-push-ecr.sh <image_repo_name> <tag>

./build-docker-and-push-ecr.sh my-app latest
# This will create an ECR Repo called "my-app", run a docker build, and push the "latest" tag to ECR
#   Choose a name and tag that works for you and your team; nothing is set in stone and this can all
#   be changed later.
```

### Terraform

```shell
cd ./terraform

# Action Required: Review the parameters in locals.tf to update service_name, stage, and container config
# This includes:
#   * The image_repo_name you chose when building docker, and the tag you pushed
#   * The DNS Configuration (hosted zone ID, Certficiate ARN, DNS Name)

# Initial deployment
terraform init
terraform apply

# Done!
```

Terraform will output some endpoints 
