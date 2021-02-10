variable "services" {
  type        = map(string)
  description = "A list of services to deploy with their Consul ACL service identity token"
}

variable "region" {
  type        = string
  description = "AWS region"
}

variable "role_arn" {
  type        = string
  description = "AWS Role ARN to assume role"
}

variable "consul_ecs_image" {
  type        = string
  default     = "joatmon08/consul-ecs:v1.9.3-v1.16.0"
  description = "image to use in Consul proxy definitions"
}

variable "kms_key_alias" {
  type        = string
  default     = "aws/secretsmanager"
  description = "KMS Key Alias for storing secrets in AWS secrets manager"
}

variable "tags" {
  type = map(string)
  default = {
    source = "hcp-consul"
  }
  description = "Tags to add to resources"
}

variable "tfc_cluster_org" {
  type        = string
  description = "TFC Organization for ECS Cluster"
}

variable "tfc_cluster_workspace" {
  type        = string
  description = "TFC Workspace for ECS Cluster"
}