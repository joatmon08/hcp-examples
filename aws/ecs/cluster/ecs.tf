module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "2.1.0"
  name    = var.name
}

module "ec2-profile" {
  source = "terraform-aws-modules/ecs/aws//modules/ecs-instance-profile"
  name   = var.name
}

data "aws_ami" "amazon_linux_ecs" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
}

module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 3.0"

  name = var.name

  # Launch configuration
  lc_name = var.name

  image_id             = data.aws_ami.amazon_linux_ecs.id
  instance_type        = "t2.micro"
  security_groups      = [aws_security_group.ecs.id]
  iam_instance_profile = module.ec2-profile.this_iam_instance_profile_id
  user_data = templatefile("./templates/user_data.sh", {
    cluster_name = var.name
  })

  # Auto scaling group
  asg_name                  = var.name
  key_name                  = var.key_name
  vpc_zone_identifier       = var.enable_public_instances ? module.vpc.public_subnets : module.vpc.private_subnets
  health_check_type         = "EC2"
  min_size                  = 0
  max_size                  = var.ecs_cluster_size
  desired_capacity          = var.ecs_cluster_size
  wait_for_capacity_timeout = 0

  tags = [
    {
      key                 = "Cluster"
      value               = var.name
      propagate_at_launch = true
    },
  ]
}