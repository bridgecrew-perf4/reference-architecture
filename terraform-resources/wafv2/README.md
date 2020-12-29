# AWS Web Application Firewall (WAF) v2 Implementation

The goal of this project is to provide a copy/paste reference implementation of AWS WAF using the v2 API. In the past, we created Terraform Modules to accomplish the task of creating global and regional wafs, but with the updated API for WAF and the implementation by Teraform, this was both unnecessary and exceedingly difficult.  As such, we decided the reference implementation was the best way to allow for a balance in ease of creation and flexibility.

## Features

* AWS WAFv2 for both CloudFront (Global) and Regional uses
* Managed Rule Groups added to the WAF
* Framework for simple disabling of rules established

## Usage

1) Copy/paste the .tf files into any terraform project that is instantiated once per account
2) Apply the changes on each account
3) Attach your various services to the relevant resources (CloudFront or ALB)
