# Lightsail Wordpress

## Bottom Line

Lightsail is a service that empowers point-and-click creation of most of the things required for a
modern webapp.  Where it falls short is being able to take an existing lightsail and inch slowly
forward into more complex configuration.  Once your app is in lightsail, it's in.  It's possible
to extract, but there's no dipping your toe in the waters.

I'm not sure who this service is for:
* For those familiar with basic AWS services, I can't say I'd recommend its use
* If you're looking to just "run wordpress", I would say a terraform VPC module and a Bitnami AMI will get you just as far, and leave you with more options in the future
* For those totally unfamiliar with AWS, this feels like granting enough power to be dangerous, but putting hard gates on the danger

## Console Defaults

Out of the box, starting a WordPress instance with lightsail launches:
* A single instance in a single AZ
* This instance is NOT visible in the traditional EC2 instance console/api
* A database running as a process on that instance
* One-click ssh access via the LightSail console
* Latest version of wordpress
* At launch, configure instance size; but this appears to be unchangeable
* Prebuilt image managed by bitnami, so no Amazon Linux

## Options

Relatively simple options
* Static IP with a couple clicks
* CloudFront Distribution can be created with pre-configured defaults for wordpress (neat!)
* CloudFront with WordPress is basically broken unless you configure a custom domain (boo!)

## Major Considerations

_ALL_ services are created without traditional AWS access.
* CloudFront has a wizard-only access
* Certificates are wizard-only; must configure Route53 separately; no button-click

Very limited Terraform support
* Instances
* Static IP
* NO CloudFront
* NO LoadBalancer
* NO Database

Weird stuff
* When using the Web Console for Lightsail with our Role Assumption, after 1 hour, we get the "Must reload..." dialog, but then it boots us out completely and need to do full MFA auth

## Spike Questions

* Can we use a separate database?
  - Yes... but managed by LightSail

* Can we store the install files on EFS?
  - LightSail creates it's own VPC, so you'd need to create a separate VPC with an EFS, configure peering, then configure access at instance startup
  - I would not recommend this

* What would migrating existing wordpress installs look like?
  - Spin up instance/database/distribution
  - Create an IAM user/key/secret to access s3 bucket with old DB dump
  - Fetch db file
  - Load into ls-database
  - Create an IAM user/key/secret with access to s3 bucket for wp-content

* Any possibility for staging/prod to test updates?
  - Not really... You could snapshot instance and database, restore to new instance/database, edit config of instance to point to new database
  - No mechanism for auto downsync

* Is load balancing possible?
  - Yes... but you still face all the problems of running load balanced wordpress; nothing push-button
  - It's unclear to me what automatic updates/plugin installations would look like for load balanced WP
  - The creation of the physical load balancer is fairly straight forward, and can be done easily enough in the GUI

Is caching/CDN possible?
  - Yes... but wrapping CloudFront behind a wizard removes a lot of the power of it
  - The basics were fairly easy to configure, came preset with some wordpress config
  - But you can't go far past the basics
