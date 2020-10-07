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
    retry_join  = var.hcp_consul_host
    certificate = base64encode(file(var.hcp_consul_ca_pem_file_path))
    token       = var.hcp_consul_client_acl_token
    encrypt_key = var.hcp_consul_gossip_encrypt
  })
}