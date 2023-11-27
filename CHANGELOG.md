# 0.3.0

* Additional ACM certificate assignment

# 0.2.1

* HOTFIX: Fix production dns_name in manifest

# 0.2.0

* SSL traffic encryption terminating at the ALB
* DNS resolution
* Update README
* Add ALB DNS name as a Terraform output
* Parameterize ECS CPU and memory
* ECS autoscaling configuration

# 0.1.0

* CloudWatch log group encryption using KMS CMK
* Build improvements to leverage callable deployment workflow and explicity manifests for development and production environments
* ECS cluster, service, task and ALB running vanilla nginx image
* KMS customer managed key provisioning with multi-region replication
* VPC network provisioning
* Github Actions Terraform workflow definition and integration
