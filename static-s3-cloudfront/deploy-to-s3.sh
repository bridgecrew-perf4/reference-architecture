#!/bin/bash -e

# Configurable Environment Variables
APP_NAME=${APP_NAME:-zombo-app}
DEV_DOMAIN=${DEV_DOMAIN:-ussba.io}
PROD_DOMAIN=${PROD_DOMAIN:-www.sba.gov}
PROD_ENVIRONMENT=${PROD_ENVIRONMENT:-production}
STATIC_CODE_DIRECTORY=${STATIC_CODE_DIRECTORY:-./static/}

# Derived Variables
BUCKET_OBJECT_PREFIX=$1
if [ "$1" == "${PROD_ENVIRONMENT}" ]; then
  BUCKET_NAME="${APP_NAME}.${PROD_DOMAIN}-static-content"
else
  BUCKET_NAME="${APP_NAME}.${DEV_DOMAIN}-static-content"
fi
BUCKET_TARGET="s3://${BUCKET_NAME}/${BUCKET_OBJECT_PREFIX}/"


if [ "$1" == "" ]; then
  echo "This script requires an environment name as first parameter

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
"
  exit 1
fi


echo "Deploying code from [${STATIC_CODE_DIRECTORY}] to [${BUCKET_TARGET}]"
aws s3 sync --delete "${STATIC_CODE_DIRECTORY}" "${BUCKET_TARGET}"
