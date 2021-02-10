data "aws_availability_zones" "available" {
  state = "available"
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.70.0"

  name                 = var.name
  cidr                 = "10.1.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
  public_subnets       = ["10.1.4.0/24", "10.1.5.0/24", "10.1.6.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = false

  public_subnet_tags = {
    key = "AmazonECSManaged"
  }

  private_subnet_tags = {
    key = "AmazonECSManaged"
  }
}
