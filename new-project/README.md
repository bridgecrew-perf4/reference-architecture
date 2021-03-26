# NEW-PROJECT

This section of the reference architecture provides high-level view on how to structure a terraform project. It will demonstrate how to manage parts of an infrastructure in different state files, describe their purpose, and provide some example code on the type of resources that should exist in each segment.

## DIRECTORY STRUCTURE

**Deployment Order**

1) bootstrap
2) account
3) application

**Note:** As new resources are created ensure that resource dependencies are top-down (eg `account` -> `application`) and <u>not</u> bottom-up (eg. `application` -> `account`) thus maintaiing an order of operational consistancy.

### THE `BOOTSTRAP` DIRECTORY

The bootstrap directory is used for one purpose and that is to prime your account(s) for use with a Terraform **remote state** and should not be used for any other purpose.

It is common for engineering teams to work on the same set of infrastructure code where an engineer will need to make independant deployments and in some cases automated deployments. This brings attention to the potential of state file conflicts. As a result Terraform has implemented a concept known as **remote state**.

A **remote state** consist of a set of resources that must exist on the account before it can be utilized by `backend` configurations, which we will discus later, after we have effectivly bootstrapped or primed the account(s). Please note that while many [backend configuration](https://www.terraform.io/docs/language/settings/backends/configuration.html) typs are supported we will only be discussing the [S3 Backend](https://www.terraform.io/docs/language/settings/backends/s3.html).

* If you have a single AWS account in which you are deploying then have a look at this [example](./bootstrap/single.tf).
* If you have multiple AWS accounts in which you are deploying then have a look at this [example](./bootstrap/multi.tf).

Please note that while other parts of your infrastructure will be using a **remote state**, the `bootstrap` will not; therefore, the any `*.tfstate` files created when issuing a `terraform apply` within the bootstrap namespace must be commited into the code repository, or you can simply re-import these resources if changes to the backend are required in the future.

### THE `ACCOUNT` DIRECTORY

This directory should contain resources that are to be replicated once per an account typically for administrative and security purpose. If you are using multiple AWS accounts please create a workspace for each account. This [example account directory](./account/) demonstrates how it can be used.

**Consider the following types of resources:**

* Cross Account IAM Roles/Policies
* Auditing Services like CloudTrail
* Security Services like GuardDuty and Inspector
* Password Policy
* Lambda@Edge functions
* Origin Access Identities (OAI's)
* Web Application Firewalls (WAF's)

Please note the `backend` configuration found in the [versions.tf](./account/versions.tf) file where the bucket and lock table are configured to match the bucket and lock table created in the `bootstrap` directory. It also important to note that the `key` must be unique per directory because these directories are representative of a distinct set of resources.

```
backend "s3" {
  # bucket name must match the one created in bootstrap
  bucket         = "remote-state-bucket-name"
  acl            = "bucket-owner-full-control"

  # unique name for this state file
  key            = "account.tfstate"

  # region in which the bucket is bound
  region         = "us-east-1"

  # table name must match the one created in bootstrap
  dynamodb_table = "remote-state-lock-table"
}
```

### THE `APPLICATION` DIRECTORY

This directory can be renamed to something more fitting (eg. myapp, cheesburger, etc) with a premise that these resources are tied to an environment (eg. dev, stg, prd, etc) where a workspace is created for each unique environment. This [example applicaiton directory](./application/) demonstrates how it can be utlized.

**Consider the following types of resources:**

* Networking Resources
  - VPCs
  - Subnets
  - Route Tables
* Servers
  - EC2 Instances (eg. ECS Cluster Instances)
  - RDS Databases
  - ElastiCache Databases
  - ECS Tasks, Services and Clusters
* Load Balancers
* CloudFront Distributions
* API Gateways
* Lambda Functions

Please note that the `backend` configuration found in the [versions.tf](./application/versions.tf) file of the `application` directory, specifically the `key` property, has been changed.

```
backend "s3" {
  # bucket name must match the one created in bootstrap
  bucket         = "remote-state-bucket-name"
  acl            = "bucket-owner-full-control"

  # unique name for this state file
  key            = "application.tfstate"

  # region in which the bucket is bound
  region         = "us-east-1"

  # table name must match the one created in bootstrap
  dynamodb_table = "remote-state-lock-table"
}
```
