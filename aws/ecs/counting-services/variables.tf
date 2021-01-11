variable "services" {
  type = map(string)
}

variable "role_arn" {}

variable "region" {
  default = "us-west-2"
}

variable "consul_ecs_image" {
  default = "joatmon08/consul-ecs:v1.9.1-v1.16.0"
}

variable "tfc_cluster_org" {}

variable "tfc_cluster_workspace" {}

variable "kms_key_alias" {
  default = "aws/secretsmanager"
}

variable "tags" {
  default = {
    source = "hcp-consul"
  }
}