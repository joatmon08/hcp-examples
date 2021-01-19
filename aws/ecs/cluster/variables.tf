variable "name" {
  default = "ecs-to-hcp-consul"
  type = string
  description = "Name of the ECS cluster and infrastructure components"
}

variable "region" {
  default = "us-west-2"
  type = string
  description = "AWS region"
}

variable "ecs_cluster_size" {
  default = 3
}

variable "hcp_consul_cidr_block" {
  default = "172.25.16.0/20"
}

variable "key_name" {
  default = ""
}

variable "enable_public_instances" {
  default = false
}

variable "role_arn" {}

variable "hcp_consul_host" {}

variable "hcp_consul_gossip_encrypt" {}

variable "hcp_consul_datacenter" {}

variable "hcp_consul_client_acl_token" {}

variable "hcp_consul_ca_pem" {}

variable "peering_connection_has_been_added_to_hvn" {
  default = false
}

variable "deploy_consul_clients" {
  default = false
}

variable "kms_key_alias" {
  default = "aws/secretsmanager"
}

variable "tags" {
  default = {
    source = "hcp-consul"
  }
}

variable "consul_ecs_image" {
  default = "joatmon08/consul-ecs:v1.9.1-v1.16.0"
}