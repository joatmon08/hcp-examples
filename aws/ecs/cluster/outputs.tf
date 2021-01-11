output "ecs_security_group" {
  value = aws_security_group.ecs.id
}

output "ecs_vpc_id" {
  value = module.vpc.vpc_id
}

output "ecs_subnet_ids" {
  value = var.enable_public_instances ? module.vpc.public_subnets : module.vpc.private_subnets
}

output "ecs_cluster_arn" {
  value = module.ecs.this_ecs_cluster_arn
}