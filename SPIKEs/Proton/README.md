# AWS Proton

## Reference Documentation

* [AWS Proton User Guide](https://docs.aws.amazon.com/proton/latest/userguide/Welcome.html)
* [Getting started with AWS Proton](https://docs.aws.amazon.com/proton/latest/userguide/ug-getting-started.html)


## **Conclusions**

**Pros**

* A much better way of orchistrating cloud formation templates.
* Environment and Service deployment version identification.
* `manifest.yaml` clue that if may offer other templatee languates.
* Environment and Services templates are reusable, design them once use them across all AWS accounts.

**Cons**

* Very little documentation at this time.
* Currently in preview so CLI needs some addional resources, but its easy.
* Warning that should not be used for production workloads yet.

## **Source Connection**

A [source connection](https://console.aws.amazon.com/codesuite/settings/connections) is used to trigger a Proton service pipeline when new commits are made to the version control system. At present the only supported version control systems are BitBucket, GitHub and GitHub Enterprise.

## **Understanding Environment and Service Templates**

To understand what these templates are we will examine the [aws-samples/aws-proton-sample-templates](https://github.com/aws-samples/aws-proton-sample-templates/tree/main/loadbalanced-fargate-svc) repository.



### **Environment Templates**

An environment template is used to control the core infrastrucutre deployment. There is virtually no documentation that describes this so lets examine the directory structure and files within that structure.


```
environment
├── infrastructure
│   ├── cloudformation.yaml
│   └── manifest.yaml
└── schema
    └── schema.yaml
```

The `infrastructure` diretory contains templates used to deplpy environment level resources (VPCs, Subnets, etc...) and a `manifest.yaml` to control which templates are provisioned and in which order. Note that templates do not contain a `Properties` block, and instead uses a `Mappings` block where variables are linked to the `schema.yaml`.

### **Service Templates**

An service template is used to control the applicaitons living on the environment. There is virtually no documentation that describes this so lets examine the directory structure and files within that structure.

```
service
├── infrastructure
│   ├── cloudformation.yaml
│   └── manifest.yaml
├── pipeline
│   ├── cloudformation.yaml
│   └── manifest.yaml
└── schema
    └── schema.yaml
```

The `infrastructure` diretory contains templates used to deplpy service level resources (ECS Tasks and Services, Lambda Functions, etc...) and a `manifest.yaml` to control which templates are provisioned and in which order. Note that templates do not contain a `Properties` block, and instead uses a `Mappings` block where variables are linked to the `schema.yaml`.

## Service

A code repository (BitBucket, GitHub, GitHub Enterprise) liked using a CodeStar connection so that commiting to the repository can kick off an AWS Proton pipeline. This pipeline could be used to deploy virtually anything as it does integrate with AWS Code Pipeline and AWS Code Build resources.