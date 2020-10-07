resource "aws_ecs_task_definition" "consul" {
  count  = var.deploy_consul_clients ? 1 : 0
  family = "consul-client"
  container_definitions = templatefile("templates/task_definition.json", {
    arn_consul_secret = aws_secretsmanager_secret.hcp_consul.0.arn
    consul_image      = "joatmon08/consul-ecs:v1.8.4-v1.14.4"
  })
  requires_compatibilities = ["EC2"]
  task_role_arn            = aws_iam_role.ecs_task.0.arn
  execution_role_arn       = aws_iam_role.ecs_task.0.arn
  network_mode             = "host"
  tags                     = {}
}

resource "aws_ecs_service" "consul" {
  count               = var.deploy_consul_clients ? 1 : 0
  name                = "consul-client"
  cluster             = module.ecs.this_ecs_cluster_arn
  task_definition     = aws_ecs_task_definition.consul.0.arn
  scheduling_strategy = "DAEMON"

  placement_constraints {
    type = "distinctInstance"
  }
}