# Convert Public S3 Buckets to Private

Are you the proud owner of a public S3 bucket that needs to have public bucket access removed? Well you've come to the right place. The SBA embraces the best practices for AWS security that suggest no S3 bucket should be public. This documentation will point you in the right direction for enabling your public S3 bucket to have direct public access removed.

If you are looking to create a new static site hosted on S3, we've got a great [example](../../static-s3-cloudfront/README.md) of how to do that in an automated fashion. Don't want the all the automation and just want to quickly deploy something? Check out our [Terraform module](https://registry.terraform.io/modules/USSBA/static-website/aws/latest)!

## Pre-requisites and Assumptions

* Access to the AWS Console
* The name of a publically accessible S3 bucket
* ACM certificate for your static site
* You are using Terraform 0.13 in a Terraform boostrapped environment

### Checking to see if your bucket is publically accessible

Chances are you've been directed here because a bucket you manage is publically accessible. But if you want to verify that, follow these steps:

* Log into your AWS account and navigate to S3
* Find your bucket in the list
* Look at the `Access` column. If it says `Public` then there is your answer

## Steps

Regardless of if your bucket was created by hand or in code, we recommend using our [static s3 website Terraform module](https://registry.terraform.io/modules/USSBA/static-website/aws/latest). This module will create a CloudFront distribution for your publically accessible bucket to sit behind. Check out the documentation for that module for information on how it works. If you have created your bucket in code, make sure to resolve any conflicts that this may create. If you aren't sure what those conflicts might be, ask someone who might!

```terraform
module "my_static_site" {
  source  = "USSBA/static-website/aws"
  version = "~> 3.0"

  domain_name                 = "static.example.com"
  acm_certificate_arn         = "arn:aws:acm:us-east-1:123412341234:certificate/1234abcd-1234-abcd-1234-abcd1234abcd"
  content_bucket_name         = "my-public-bucket"
  hosted_zone_id              = "Z0123456789ABCDEFGHIJ" # Optional input variable; If provided will create the Route53 recordset for you, otherwise you'll need to map the cloudfront DNS yourself.
  default_subdirectory_object = "index.html"
}
```

Once this is in place do a simple `terraform plan` to verify the changes and then a `terraform apply` to apply the changes. Verify that your content is now accessible via CloudFront. Notify whoever has been bugging you about your bucket that it now can have public access removed.
