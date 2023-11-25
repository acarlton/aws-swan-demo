# AWS ECS Demo

A demo application featuring deployment and CI/CD for a Hello World application on AWS ECS Fargate. Infrastructure is defined in Terraform code and deployed automatically.

## Features

* Repository build process and CI/CD with Github Actions using an OIDC integration with AWS
* Basic VPC networking consisting of:
    * 2 public subnets
    * 2 private subnets
    * Internet gateway
    * NAT gateway
    * External traffic routing tables
* An ECS cluster, service and task running a basic Hello World web application
* Simple autoscaling configuration for ECS service based on CPU and memory target utilization
* An application load balancer receiving public traffic and forwarding to ECS in private subnets
* Definition of a KMS customer managed key for encryption, with support for cross-region replication to enable future multi-region deployments
* CloudWatch logging with KMS CMK encryption

## Contributing

This is a demo project, and doesn't expect to attract contributors, but for the sake of exposition, here is a section on development practices.

We use the [git-flow](https://nvie.com/posts/a-successful-git-branching-model) where features are implemented in `feature/*` branches and staged into `develop`. Releases are tagged and merged into `main`, which tracks the current stable state of production code.

Generally, pull requests that contain a more-or-less complete feature implementation are squash-merged into `develop`.

[CHANGELOG.md](CHANGELOG.md) keeps a record of the features in each release and new work should be documented in the "Unreleased" section until the next release.

Whenever we get around to customizing the Docker image into a more complicated application, we will be using the [3musketeers](https://github.com/flemay/3musketeers) pattern to standardize an interface for common development tasks and processes.
