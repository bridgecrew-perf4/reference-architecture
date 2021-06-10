# AWS CloudFront Functions

## Questions

### What is a CloudFront Function?

Lightweight functions in JavaScript for high-scale, latency-sensitive CDN customization's. These functions can manipulate the requests and responses that flow through CloudFront, perform basic authentication and authorization, generate HTTP responses at the edge, and more. The CloudFront Functions runtime environment offers submillisecond startup times, scales immediately to handle millions of requests per second, and is highly secure. CloudFront Functions is a native feature of CloudFront, which means you can build, test, and deploy your code entirely within CloudFront.

### How are CloudFront Function different from Lambda@Edge Functions?

There are several distinct differences between the two.

A CloudFront Function:

1. only supports javascript language.
2. is a single file.
3. may only use viewer-request and viewer-response.
4. must have a function/method named `handler`.
5. is manage via CloudFront dashboard.


### How do I write a CloudFront Function?

* [Tutorial: Creating a simple function with CloudFront Functions](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/functions-tutorial.html)
<br/>A simple function to get your hands dirty.

* [JavaScript runtime features for CloudFront Functions](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/functions-javascript-runtime-features.html)
<br/>Details all of the runtime features that are supported and restricted.

* [Writing function code (CloudFront Functions programming model)](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/writing-function-code.html)
<br/>The basic structure and thought process of working with these functions.
<br/><br/>***Note:** When you modify an HTTP response with CloudFront Functions, you cannot alter or modify the response body. If you need to alter the response body, use Lambda@Edge.*

* [Github: Amazon CloudFront Functions](https://github.com/aws-samples/amazon-cloudfront-functions)
<br/>A collection of commonly used functions that will make life a bit easier.
