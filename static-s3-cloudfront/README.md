## Initial Setup

### AWS

Your AWS credentials must be configured to point to the correct account.

To test them, run `aws sts get-caller-identity`

## Deployment

Executing "./deploy-to-s3.sh" without providing an environment name will print
out a robust usage message.  The script can be configured with environment variables
and supports deployment to any number of dev environments, and a single production environment.

* For non-production environments, files will be sent to a sub-directory in the target bucket.
* For the production environment, files will be copied to the root of the bucket.

Quick examples:
```
dev-bucket
├── dev
│   └── index.html   # Viewable at https://<dev-domain>/dev/index.html
└── ticket-1234
    ├── index.html   # Viewable at https://<dev-domain>/ticket-1234/index.html
    └── new-file-for-ticket-1234.js
production-bucket
└── index.html       # Viewable at https://<prod-domain>/index.html
```


```
Usage:

  $0 <environment-name>

  If environment name matches \$PROD_ENVIRONMENT [currently, '${PROD_ENVIRONMENT}'], deployment will go
  to the production domain bucket, and the bucket contents will be in the root.  For every other domain
  the deployment will subdirectoried/prefixed with the name of the environment.
  This allows for deployment of any number of test environments.

Examples, based on current configuration:

  \$ $0 dev
     ## Copies files like [${STATIC_CODE_DIRECTORY}index.html] to [s3://${APP_NAME}.${DEV_DOMAIN}-static-content/dev/index.html]
     ## Files are available to view at: https://${APP_NAME}.${DEV_DOMAIN}/dev/index.html
  \$ $0 ${PROD_ENVIRONMENT}
     ## Copies files like [${STATIC_CODE_DIRECTORY}index.html] to [s3://${APP_NAME}.${PROD_DOMAIN}-static-content/index.html]
     ## Files are available to view at: https://${APP_NAME}.${PROD_DOMAIN}/index.html


Environment Variables can be provided. They have been created with defaults, and the current value is shown below:

  APP_NAME=${APP_NAME}
  DEV_DOMAIN=${DEV_DOMAIN}
  PROD_DOMAIN=${PROD_DOMAIN}
  PROD_ENVIRONMENT=${PROD_ENVIRONMENT}
  STATIC_CODE_DIRECTORY=${STATIC_CODE_DIRECTORY}
```
