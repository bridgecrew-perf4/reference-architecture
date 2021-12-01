# Control Tower

AWS Control Tower is a service that is intended for organizations with multiple accounts and teams who are looking for the easiest
way to set up their new multi-account AWS environment and govern at scale. With AWS Control Tower, cloud administrators get peace of
mind knowing accounts in their organization are compliant with established policies while builders provision new AWS accounts quickly in a few clicks.

AWS Control Tower comes with a set of preset rules. These contain `mandatory` rules which are on by default and rules that you can elect to be turned on.

[Guardrails Introduction](https://docs.aws.amazon.com/prescriptive-guidance/latest/designing-control-tower-landing-zone/welcome.html)
[Guardrails in AWS Control Tower](https://docs.aws.amazon.com/prescriptive-guidance/latest/designing-control-tower-landing-zone/guardrails.html)

## Rules

Mandatory guardrails are enabled by default when you set up your landing zone and can't be disabled.

### Mandatory Rules

The rules below are mandatory rules enabled by default.

[Mandatory guardrails](https://docs.aws.amazon.com/prescriptive-guidance/latest/designing-control-tower-landing-zone/mandatory-guardrails.html)

- Disallow changes to the encryption configuration of Amazon Simple Storage Service (Amazon S3) buckets created by AWS Control Tower in the Log Archive account
- Disallow changes to the logging configuration of S3 buckets created by AWS Control Tower in the Log Archive account
- Disallow changes to the bucket policy of S3 buckets created by AWS Control Tower in the Log Archive account
- Disallow changes to the lifecycle configuration of S3 buckets created by AWS Control Tower in the Log Archive account
- Disallow changes to Amazon CloudWatch Logs log groups
- Disallow the deletion of AWS Config aggregation authorization
- Disallow the deletion of the Log Archive account
- Disallow public Read access to the Log Archive account
- Disallow public Write access to the Log Archive account
- Disallow configuration changes to AWS CloudTrail
- Integrate CloudTrail events with CloudWatch Logs
- Enable CloudTrail in all available AWS Regions
- Enable integrity validation for CloudTrail log files
- Disallow changes to Amazon CloudWatch set up by AWS Control Tower
- Disallow changes to AWS Config aggregation set up by AWS Control Tower
- Disallow configuration changes to AWS Config
- Enable AWS Config in all available AWS Regions
- Disallow changes to AWS Config rules set up by AWS Control Tower
- Disallow changes to AWS Identity and Access Management (IAM) roles set up by AWS Control Tower
- Disallow changes to AWS Lambda functions set up by AWS Control Tower
- Disallow changes to Amazon Simple Notification Service (Amazon SNS) set up by AWS Control Tower
- Disallow changes to Amazon SNS subscriptions set up by AWS Control Tower

### Strongly Recommended Rules

The rules below are are not rules that are mandatory but are highly recommended and were turned on by the organization.

[Guardrail Rules](https://docs.aws.amazon.com/prescriptive-guidance/latest/designing-control-tower-landing-zone/strongly-recommended-elective-guardrails.html)

- Detect whether MFA is enabled for AWS IAM users of the AWS Console
- Detect whether storage encryption is enabled for Amazon RDS database instances
- Detect whether public access to Amazon RDS database instances is enabled
- Detect whether MFA for the root user is enabled
- Detect whether public read access to Amazon S3 buckets is allowed

With the transition to Fargate this rule becomes less and less necessary. However, if there are accounts still using EC2 this could be worthy

- Detect whether encryption is enabled for Amazon EBS volumes attached to Amazon EC2 instances

## Rules Worth Enabling

Below are rules from the strongly recommended list that are not currently enabled across the organization. Out of the list of strongly recommended I think these are rules that follow
the SBA's security posture and are worth enabling.

- Detect whether public access to Amazon RDS database snapshots is enabled
- Detect whether unrestricted internet connection through SSH is allowed
- Detect whether public write access to Amazon S3 buckets is allowed
- Disallow creation of access keys for the root user

## Custom Rules

You can implement custom SCPs and AWS Config rules to cover use cases that are specific to your organization. However, these are not implemented
as AWS Control Tower guardrails, but as custom SCPs and AWS Config configurations outside AWS Control Tower

[Amazon Doc](https://docs.aws.amazon.com/prescriptive-guidance/latest/designing-control-tower-landing-zone/custom-guardrails.html)

While you can create custom rules, It's probably not necessary unless you want auto remediation. Out of the box AWS Control Tower will notify an administrator of drift that has occured in resources and a rule set. Custom rules can be created to automatically correct a specific
issue, such as, `this security group had a port opened automatically remove it` instead of just receiving a notification.

