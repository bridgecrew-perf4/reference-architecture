# App Runner 

## Bottom Line

App Runner is a "fully managed" service that is meant to make it easier for developers to quickly deploy their containerized web applications and APIs. 

The service could potentially get better, however, at this current time I do not believe it really has any benefit to the SBA. Since most SBA
applications require a database, which in return, also requires a VPC which would be managed by Terraform, I feel the USSBA/easy-fargate-service is actually more beneficial
and I think easier to use. 

## Major Considerations
 
App Runner does not create the following resources and it also does not support taking the below resources as arguments for a micro service deployment.
  - VPC.
  - Databases (RDS/Dynamo).
  - S3 Buckets.
  - Does not have capability to adjust ci/cd beyond your container being deployed.
  - One container per "app_runner" resource.

App Runner essentially just deploys your containers and does not deploy / configure any outside infrastructure that your application may need to actually work.
  - VPC & ECS cluster it deploys your application to are abstracted away from the engineer and appears "serverless".

**DISLAIMER**: Possible bug with aws_apprunner_service. There appears to be a race condition where sometimes the service creates the IAM Role, Policy, and the service
and other times it creates the IAM Role, Policy, errors out, and on re-deploy works fine. Attempted to add depends_on to resources but am having the same problem. 

## Spike Questions
 
- Does it support multi container deployments?
  - App Runner automatically builds and deploys the web application and load balances traffic with encryption
  - App Runner also scales up or down automatically to meet your traffic needs
- Does Terraform support it?
  - Terraform supports [App Runner](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apprunner_service)
- Difference between this and lightsail?
  - App Runner does have the ability to deploy code based on changes to the code base.
  - App Runner does have Terraform support.

## Documentation

[Get Started](https://aws.amazon.com/apprunner/)

## Example:

```main.tf``` contains the bare minimum to deploy an ecs service using a image from ECR. For this spike I am passing in the ECR image as a environment variable.

```sh
tf apply -var image_identifier=${account_id}.dkr.ecr.us-east-1.amazonaws.com/helloworld:latest
```
