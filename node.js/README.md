# Node.js Reference Architecture

The goal of this project is to provide a sample configuration for creating a serverless deployment of node.js, with persistent infrastructure managed by Terraform

## Features

* Node.js deployed to Lambda with Serverless
* Terraform managing:
  * RDS
  * Security Groups
  * IAM Permissions
  * API Gateway top-level resource
  * Secrets and other parameters using AWS Parameter Store
* Serverless managing:
  * Lambda deployments
  * API Gateway resources and paths
* Decouples infrastructure deployment from application deployment
  * Terraform creates parameters in AWS Parameter Store
  * Serverless pulls required configuration at deploy-time directly from Parameter Store

## Prerequisites

* node.js
* nvm (optional)
* AWS credentials available to your shell
* Terraform 0.13+

## Deployment Process

### Terraform

```shell
cd ./terraform

# Action Required: Review the parameters in locals.tf to update service_name and environment

# Initial deployment
terraform init
terraform apply

# Done!
```

### Serverless

```shell
# Install version of node.js if you don't have it
nvm install
nvm use

# Install dependencies, including Serverless
npm install -g serverless@v2
npm install

# Action Required: Review the parameters in locals.tf to update service_name and environment

# Run a serverless deployment (sls == serverless alias)
sls deploy
```

Then follow the instructions to hit your application endpoint for testing.
