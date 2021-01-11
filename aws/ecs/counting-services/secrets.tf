resource "random_string" "secret_name" {
  length  = 8
  special = false
}

resource "aws_secretsmanager_secret" "service" {
  for_each                = var.services
  name                    = "${each.key}-${random_string.secret_name.result}"
  recovery_window_in_days = 0
  tags                    = var.tags
}

resource "aws_secretsmanager_secret_version" "service" {
  for_each      = var.services
  secret_id     = aws_secretsmanager_secret.service[each.key].id
  secret_string = each.value
}