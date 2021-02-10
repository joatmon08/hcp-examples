variable "name" {
  type        = string
  description = "Name of the ECS cluster and infrastructure components"
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
  description = "image to use in Consul client definitions"
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

variable "ecs_cluster_size" {
  type        = number
  default     = 3
  description = "Size of the ECS cluster"
}

variable "hcp_consul_cidr_block" {
  type        = string
  default     = "172.25.16.0/20"
  description = "CIDR block of the HashiCorp Virtual Network"
}

variable "key_name" {
  type        = string
  default     = ""
  description = "Key pair name to log into the instances"
}

variable "enable_public_instances" {
  type        = bool
  default     = false
  description = "Create ECS container instances in public subnet"
}

variable "hcp_consul_public_endpoint" {
  type        = string
  default     = false
  description = "Enable HCP Consul public endpoint for cluster"
}

variable "hcp_consul_datacenter" {
  type        = string
  default     = ""
  description = "Name of Consul datacenter"
}

variable "deploy_consul_clients" {
  type        = bool
  default     = false
  description = "Enable Consul clients."
}



