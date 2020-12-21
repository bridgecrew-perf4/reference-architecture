# Reference Architecture: Node.js Lambda with DynamoDB

## Features

* Terraform manages DynamoDB and IAM Permissions
* Serverless manages Application Deployment

## Initial Setup

### Prerequisites

* node.js 12
* nvm (optional, but recommended for ease of `nvm use`)
* AWS credentials available to your shell
* Terraform 0.13+
* Serverless cli 2 (`npm i -g serverless@2`)
* Serverless offline (`npm i -g serverless-offline`)
* Docker/Docker Compose (optional for offline dynamodb testing)

### Variables

To deploy these services, you'll need a service name, and one or many environment name/s.  These will need to be consistent between serverless and terraform

* Service Name
  * `service` field in `serverless.yml`
  * `./terraform/locals.tf` - `service_name` local variable
* Environment Name
  * `provider -> stage` field in `serverless.yml` to set the default
  * `serverless deploy --stage <foo>` when using something other than the default
  * `./terraform/locals.tf` - `environment` local variable OR use terraform workspaces

### Terraform

The infrastructure is intended to be deployed once per environment.  Once for dev, and once for prod.  This can
be accomplished in a number of ways with terraform.  Copying the directory; copying the resources;
creating a subdirectory/local-module; using workspaces; etc.

The following is how to deploy the initial configuration.

* `cd terraform/`
* Configure `locals.tf`'s `locals` block to your desried settings
* If using workspaces (recommended), create your workspace with `terraform workspace new dev` (or `prod`, `staging`, etc). This step should be performed once per workspace.
* If using workspaces, select your workspace with `terraform workspace select dev`.  This step should be performed when switching between workspaces.
* Run `terraform init` then `terraform apply`.  This will create the backend resources, roles, and permissions

### Serverless

Serverless cli is used to deploy and manage Lambda and API Gateway resources.  This allows for a much nicer
deployment process from a developer perspective, and doesn't require knowledge of any AWS resources.

* From the base directory
* Configure `serverless.yml` as described above
* Run `serverless deploy --stage <environment>`
* Serverless will output a path for you to test your code

### Serverless Offline

To simulate running serverless offline, including an offline dynamodb here's an example using docker:

* Install serverless-offline: `npm i -g serverless-offline`
* Uncomment the plugins block of serverless.yml; add `serverless-offline`
* Start a docker daemon with docker-compose: `docker-compose up -d`
* Run serverless offline: `sls offline start`
* Connect to serverless locally:
  * `http://localhost:3000/dev/`
  * `http://localhost:3000/dev/foo`
  * `http://localhost:3000/dev/bar`
  * `http://localhost:3000/dev/bad-hits`


## Next Steps

* Configure a backend for terraform to live in S3.  We created a [terraform module](https://github.com/USSBA/terraform-aws-bootstrapper/) to help with this.
* If this application will have two AWS accounts (one for dev/lower, one for prod/upper), create a separate deployment in the other account
* If your application lives behind a separate CloudFront, you can add the paths output by serverless to your CF Origins/Behaviors
  * Example of [CloudFront Origin](https://github.com/USSBA/sba-gov-infrastructure/blob/7118331/terraform/application/cloudfront.tf#L162-L173)
  * Example of [CloudFront Behavior](https://github.com/USSBA/sba-gov-infrastructure/blob/7118331/terraform/application/cloudfront.tf#L382-L399)
* If this application will be standalone, you can configure an API Gateway Custom Domain Name and direct it to a specific stage
  * Example of [API Gateway Domain Name + Deployment](https://github.com/USSBA/sba-gov-infrastructure/blob/7118331/terraform/application/katana-serverless.tf#L53-L62)
    * **Note**: Adding terraform for API Gateway Deployment will cause an error on the first run of Terraform before deploying serverless.  To work around, run terraform again after serverless deploy.
  * Example of [Route53 Record with API-GW Domain](https://github.com/USSBA/sba-gov-infrastructure/blob/7118331/terraform/application/dns.tf#L45-L55)
