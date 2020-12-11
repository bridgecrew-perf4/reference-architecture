#!/bin/bash

if [ -z $1 ]; then
  echo "error: first parameter should be the image name to be pushed (eg: foo, bar).  Optionally, the second parameter can be passed to set a tag-name.  'latest' will be used by default"
  exit 10
fi

image_name=$1
image_tag=${2:-latest}

aws_version=$(aws --version)
aws_account_id=$(aws sts get-caller-identity --query Account --output text)
aws_region=us-east-1
aws_ecr_image_prefix=${aws_account_id}.dkr.ecr.${aws_region}.amazonaws.com

function aws-docker-tag-for-ecr(){
  image=$1
  docker tag "${image}" "${aws_ecr_image_prefix}/${image}"
}
function aws-docker-push-to-ecr(){
  image=$1
  docker push "${aws_ecr_image_prefix}/${image}"
}

function aws-docker-login(){
  if echo $aws_version | grep 'aws-cli/1'; then
    echo "aws-cli v1 detected. Logging in to ecr docker..."
    `aws ecr get-login --no-include-email --region ${aws_region}`
  elif echo $aws_version | grep 'aws-cli/2'; then
    echo "aws-cli v2 detected. Logging in to ecr docker..."
    aws ecr get-login-password --region "${aws_region}" \
      | docker login --username AWS --password-stdin "${aws_ecr_image_prefix}"
  fi
}

function aws-ecr-create-repo-if-not-exists(){
  image_name=$1
  aws ecr describe-repositories --repository-name "${image_name}" > /dev/null 2>&1
  if [ "$?" != "0" ]; then
    read -p "ECR Repository [${image_name}] does not exist.  Would you like to create it? [y/N] " -r
    if [[ ! $REPLY =~ ^[Yy][Ee]?[Ss]?$ ]]; then
      echo "Exiting without creating a new ECR Repository. Please create one, or rerun this script and hit 'Y' instead."
      exit 20
    else
      echo "Creating repository [${image_name}]"
      aws ecr create-repository --repository-name "${image_name}" > /dev/null
    fi
  fi
}

aws-ecr-create-repo-if-not-exists ${image_name}
docker build -t "${image_name}" .
aws-docker-login
aws-docker-tag-for-ecr ${image_name}:${image_tag}
aws-docker-push-to-ecr ${image_name}:${image_tag}
