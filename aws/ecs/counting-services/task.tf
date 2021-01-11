resource "aws_ecs_task_definition" "service" {
  for_each = var.services
  family   = each.key
  container_definitions = templatefile("templates/${each.key}.json", {
    secret_arn   = aws_secretsmanager_secret.service[each.key].arn
    consul_image = var.consul_ecs_image
  })
  requires_compatibilities = ["EC2"]
  task_role_arn            = aws_iam_role.service.arn
  execution_role_arn       = aws_iam_role.service.arn
  network_mode             = "awsvpc"
  tags                     = {}
}

data "terraform_remote_state" "ecs" {
  backend = "remote"

  config = {
    organization = var.tfc_cluster_org
    workspaces = {
      name = var.tfc_cluster_workspace
    }
  }
}

resource "aws_ecs_service" "service" {
  for_each        = var.services
  name            = each.key
  cluster         = data.terraform_remote_state.ecs.outputs.ecs_cluster_arn
  task_definition = aws_ecs_task_definition.service[each.key].arn
  desired_count   = 1
  network_configuration {
    subnets         = data.terraform_remote_state.ecs.outputs.ecs_subnet_ids
    security_groups = [data.terraform_remote_state.ecs.outputs.ecs_security_group]
  }
}