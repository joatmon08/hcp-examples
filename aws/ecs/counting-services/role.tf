data "aws_kms_key" "secrets_manager" {
  key_id = "alias/${var.kms_key_alias}"
}

resource "aws_iam_policy" "service" {
  for_each    = var.services
  name        = "${each.key}-ecs-secrets-policy"
  path        = "/ecs/"
  description = "Permissions for secrets related to ${each.key} service on ECS"

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
        "${aws_secretsmanager_secret.service[each.key].arn}",
        "${data.aws_kms_key.secrets_manager.arn}"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role" "service" {
  name = "services-ecs-secrets-role"
  path = "/ecs/"

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

resource "aws_iam_role_policy_attachment" "service" {
  for_each   = var.services
  role       = aws_iam_role.service.id
  policy_arn = aws_iam_policy.service[each.key].arn
}
