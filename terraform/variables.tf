variable "aws_region" {
  default     = "us-east-1"
  description = "The AWS region name in which the main infrastructure should be deployed"
  type        = string
}

variable "aws_replication_region" {
  default     = "us-west-2"
  description = "The AWS replication region where resources are provisioned for failover"
  type        = string
}

variable "environment" {
  description = "Name of the provisioned environment for namespacing purposes"
  type = string
}
