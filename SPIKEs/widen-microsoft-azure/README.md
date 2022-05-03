# Widen/cloudfront-auth

## Microsoft Azure

### Description

Figure out how to integrate cloudfront-auth with Microsoft Azure AD.

### Conclusion

The project is rather easy to build, pull the code, run the **build.sh** script and fill in the blanks. Question comes in trying to manage the result of running the **build.sh** because it generatres `id_rsa` and `id_rsa.pub` key files, embeds the key as part of the `config.json`.

At present I have creatd a private S3 bucket `oig.sba.gov-cloudfront-auth` in the `Inspector-General-Upper` account.

Initially you will need to run the following command using the AWS command line:

```
cd <directory-of-choice>
aws s3 sync s3://oig.sba.gov-cloudfront-auth .
```

From there you can simply use the `sync.sh` script:

**Note:** This process will only be temporary until we can find a better way of securing the generated code and key.

```bash
# to push changes up
./sync up

# to pull changes down
./sync down
```

### IAM Lambda Execution Role

Add the following policies to the Lambda execution role:

* AWSLambdaBasicExecutionRole
* AWSLambda_FullAccess

Update your Roles Trust policy:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": [
                    "lambda.amazonaws.com",
                    "edgelambda.amazonaws.com"
                ]
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
```



### Identity Provider Guide

See [Microsoft Azure](https://github.com/Widen/cloudfront-auth#microsoft-azure)

Please see the following support issue:

- [Issue #94 - Please, enhance the documentation](https://github.com/Widen/cloudfront-auth/issues/94)
- [Issue #87 - Redirect Loop Error](https://github.com/Widen/cloudfront-auth/issues/87)

### Configure Lambda and CloudFront

See [Manual Deployment](https://github.com/Widen/cloudfront-auth/wiki/Manual-Deployment) or [AWS SAM Deployment](https://github.com/Widen/cloudfront-auth/wiki/AWS-SAM-Deployment)
