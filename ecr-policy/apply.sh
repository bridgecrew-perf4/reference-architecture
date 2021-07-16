#!/bin/bash
REPOS=(`aws ecr describe-repositories --output text --query repositories[].repositoryName`)
for r in ${REPOS[@]};
do
  echo "Repository Name: $r"
  echo "Enable scanning once image is pushed."
  aws ecr put-image-scanning-configuration --repository-name "${r}" --image-scanning-configuration scanOnPush=true > /dev/null 2>&1
  echo "Enable lifecycle policy to remove untagged images after 14 days."
  aws ecr put-lifecycle-policy --repository-name "${r}" --lifecycle-policy-text 'file://policy.json' > /dev/null 2>&1
done

