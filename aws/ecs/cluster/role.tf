data "aws_kms_key" "secrets_manager" {
  key_id = "alias/${var.kms_key_alias}"
}

resource "aws_iam_policy" "consul_clients" {
  count       = var.deploy_consul_clients ? 1 : 0
  name        = "${var.name}-consul-clients"
  path        = "/ecs/"
  description = "Permissions for secrets related to Consul clients"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "secretsmanager:GetSecretValue",
        "kms:Decrypt"
      ],
      "Resource": [
        "${aws_secretsmanager_secret.hcp_consul.0.arn}",
        "${data.aws_kms_key.secrets_manager.arn}"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role" "consul_clients" {
  count = var.deploy_consul_clients ? 1 : 0
  name  = "${var.name}-consul-clients"
  path  = "/ecs/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "consul_clients" {
  count      = var.deploy_consul_clients ? 1 : 0
  role       = aws_iam_role.consul_clients.0.id
  policy_arn = aws_iam_policy.consul_clients.0.arn
}
