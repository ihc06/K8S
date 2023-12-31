terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.9"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = local.vpc_name
  cidr = local.vpc_cidr

  azs = ["${var.aws_region}a", "${var.aws_region}b"]

  public_subnets = [
    cidrsubnet(local.vpc_cidr, 8, 0),
    cidrsubnet(local.vpc_cidr, 8, 1)
  ]

  private_subnets = [
    cidrsubnet(local.vpc_cidr, 8, 2),
    cidrsubnet(local.vpc_cidr, 8, 3)
  ]

  enable_nat_gateway   = true
  single_nat_gateway   = false
  enable_dns_hostnames = true


  tags = merge(
    {
      Name = local.vpc_name
    },
    local.common_tags
  )
  
# Public subnets need to have the required tags for load balancer placement

#   public_subnet_tags = {
#     "kubernetes.io/role/elb"                        = "1"
#     "kubernetes.io/cluster/${local.prefix}-cluster" = "owned"
#   }
}