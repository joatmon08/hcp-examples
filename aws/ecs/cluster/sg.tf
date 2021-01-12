resource "aws_security_group" "ecs" {
  name        = "ecs-container-instances"
  description = "ECS security group"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group_rule" "ssh" {
  count             = var.enable_public_instances ? 1 : 0
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ecs.id
}

resource "aws_security_group_rule" "egress_ecs" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ecs.id
}

resource "aws_security_group_rule" "https_client" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ecs.id
  security_group_id        = aws_security_group.ecs.id
  description              = "Allow all TCP traffic between ECS container instances"
}

resource "aws_security_group_rule" "lan_gossip" {
  type                     = "ingress"
  from_port                = 8301
  to_port                  = 8301
  protocol                 = "tcp"
  source_security_group_id = module.eks.cluster_primary_security_group_id
  security_group_id        = aws_security_group.ecs.id
  description              = "Allow all TCP traffic between consul clients"
}

resource "aws_security_group_rule" "ingress_hcp" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = [var.hcp_consul_cidr_block]
  security_group_id = module.eks.cluster_primary_security_group_id
  description       = "Allow all TCP traffic between HCP and EKS"
}