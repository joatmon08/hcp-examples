locals {
  hcp_consul_config_file    = jsondecode(base64decode(hcp_consul_cluster.consul.consul_config_file))
  hcp_consul_ca_pem         = hcp_consul_cluster.consul.consul_ca_file
  hcp_consul_client_token   = hcp_consul_cluster.consul.consul_root_token_secret_id
  hcp_consul_gossip_encrypt = local.hcp_consul_config_file.encrypt
  hcp_consul_retry_join     = local.hcp_consul_config_file.retry_join.0
}

resource "random_string" "secret_name" {
  count   = var.deploy_consul_clients ? 1 : 0
  length  = 8
  special = false
}

resource "aws_secretsmanager_secret" "hcp_consul" {
  count                   = var.deploy_consul_clients ? 1 : 0
  name                    = "${var.name}-${random_string.secret_name.0.result}"
  recovery_window_in_days = 0
  tags                    = var.tags
}

resource "aws_secretsmanager_secret_version" "hcp_consul" {
  count     = var.deploy_consul_clients ? 1 : 0
  secret_id = aws_secretsmanager_secret.hcp_consul.0.id
  secret_string = jsonencode({
    retry_join  = local.hcp_consul_retry_join
    certificate = local.hcp_consul_ca_pem
    token       = local.hcp_consul_client_token
    encrypt_key = local.hcp_consul_gossip_encrypt
  })
}