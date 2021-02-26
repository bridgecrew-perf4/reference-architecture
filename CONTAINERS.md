# Containers

## Images
There are three types of container images:
1. Baseline - foundational images (e.g. NGINX) that other container images are built from
2. CI/CD - working images (e.g. Packer) that are used to run integration, build, and deployment jobs
3. Application - runtime images that real applications run off of as a part of daily operations

### Strategy
Reduce our management burden by leaning on community maintained images and leveraging managed service providers.

### Baseline
Lean on the wider community of image maintainers and consume these directly.  
[ubuntu:20.04](https://hub.docker.com/_/ubuntu)

Limit the attack surface by using the smallest reasonable operating system.
[alpine:latest](https://hub.docker.com/_/alpine)

Open questions:
- Do we cache images in our own private repository for a period of time?
- Do we use latest for Operating Systems?

### CI/CD
Leverage managed services (e.g. CircleCI) and managed images (e.g. Orbs) for CI/CD.
[Orb: circleci/aws-cli](https://circleci.com/developer/orbs/orb/circleci/aws-cli)

### Application
For applications, manage as few custom container images as we responsibly can.

Web servers with proven track records that support backwards compatability can use ```:latest``` tags:
[nginx:latest](https://hub.docker.com/_/nginx)

Applications that require deterministic builds can use ```:version``` specific tags:
[drupal:8.9-fpm](https://hub.docker.com/_/drupal)
