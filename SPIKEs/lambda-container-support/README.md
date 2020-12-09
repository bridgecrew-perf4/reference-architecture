# Lambda Container Support

## Pros

- Docker is a standard way of packaging up an application and being able to deploy them using Lambda and API Gateway feels real good
- Base images provided and actively maintained by AWS for the supported Lambda runtimes (Python, Node.js, Java, .NET, Go, Ruby) and for custom runtimes
- Ability to use your own Docker images when you implement the [Lambda Runtime API](https://docs.aws.amazon.com/lambda/latest/dg/runtimes-api.html)
- More flexible with language, dependencies, OS, etc
- Larger file size allowed (10GB docker image vs 50MB zip file)
- Local testing of the container image for Lambda is provided by the [Lambda Runtime Interface Emulator](https://github.com/aws/aws-lambda-runtime-interface-emulator/)
- AWS maintained images are in both [Docker Hub](https://hub.docker.com/search?q=amazon%2Faws-lambda&type=image) or [ECR Public](https://gallery.ecr.aws/)
- Lambda scales automatically based on requests and idle workloads are not costing money (unlike Fargate)
- Lambda has better native intergration with AWS services than Fargate (which requries a bit more leg work for integration)

## Cons

- Fargate sits on dedicated resources so performance is going to be faster and more consistent
- Going to have the occasional slow response time when scaling from zero
- Limit of a 10GB container could be hit **very** easily
- Lambda execution is limited to 15 minutes
- Lambda is limited to the amount of compute resources it can consume
- Less ideal for resource intensive processes

## Questions

- How is this different from Fargate?
  - I see this as mainly another way to package up a Lambda function in a way that may feel more approachable to a software engineer, not as a replacement for Fargate or for a traditional Lambda

- What does it cost? Is it more or less expensive than Fargate?
  - Lambda is charged when the function is executed while Fargate's cost accumulated while it is running (vCPU per hour)
  - It depends on the app which one is more or less expensive (e.g. if an endpoint is hit infrequently it would make more sense to deploy it on Lambda instead of having the service running constantly on Fargate with very little traffic)

- Automation and management?
  - Deployment can be handled the same way we already handle Lambda deployments using [Serverless](https://www.serverless.com/framework/docs/providers/aws/guide/functions#referencing-container-image-as-a-target). See the [example directory](example/) for a basic implementation.
  - [Terraform](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function#image_uri) also supports deploying Lambdas with container images

## Conclusions

AWS Lambda Container Image Support is a compelling marriage of serverless architecture and containerization of applications in a way that makes AWS Lambda very approachable for a broader audience of software engineers. The benefits and drawbacks of Lambda remain unchanged but the barrier for entry into serverless applications is now much lower.

## Sources

- [AWS Blog post](https://aws.amazon.com/blogs/aws/new-for-aws-lambda-container-image-support/)
- [AWS Lambda documentation](https://docs.aws.amazon.com/lambda/latest/dg/runtimes-images.html)
- [Pulumi blog post](https://www.pulumi.com/blog/aws-lambda-container-support/)
- Serverless - [referencing container image as a target](https://www.serverless.com/framework/docs/providers/aws/guide/functions#referencing-container-image-as-a-target)
