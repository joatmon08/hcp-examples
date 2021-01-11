terraform {
  required_version = "~>0.13"
  required_providers {
    aws = {
      version = "~> 3.23.0"
    }
    random = {
      version = "~> 3.0.0"
    }
  }
}

provider "aws" {
  region = var.region
  assume_role {
    role_arn = var.role_arn
  }
}