# Automated CIRCLECI Context/AccessKey Rotation

## Description

Detect if the target IAM user has any expired IAM access keys and if so removes **ALL** associated access keys, provision a new access key, and update the AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY secrets on a given CIRCLECI context.

## Build Environment

To build the image you simply need Docker and an internet connection.

## Container Environment

### `CIRCLECI_CLI_TOKEN`

Token provided by CIRCLECI in order to use the `circleci` CLI tool and/or API.

**Required:** True, **Case:** Sensitive

### `CIRCLECI_CONTEXT`

A comma separated list of `circleci` context names to update of when a rotation is triggered.

**Required:** True, **Case:** Sensitive

### `CIRCLECI_ORG`

The name of the GitHub organization associated to the context.

**Required:** True, **Case:** Sensitive

### `IAM_USER_NAME`

Name of the IAM user on the targeted AWS account.

**Required:** True, **Case:** Insensitive
