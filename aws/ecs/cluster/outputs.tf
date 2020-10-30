output "ecs_security_group" {
  value = aws_security_group.ecs.id
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "ecs_cluster" {
  value = var.name
}