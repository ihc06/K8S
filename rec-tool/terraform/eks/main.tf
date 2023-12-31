locals {
  remote_state_bucket_region    = "us-east-1"
  remote_state_bucket           = "talrise-remote-state-s3"
  infrastructure_state_file     = "eks-talrise-vpc.tfstate"

  prefix          = data.terraform_remote_state.vpc.outputs.prefix
  common_tags     = data.terraform_remote_state.vpc.outputs.common_tags
  vpc_id          = data.terraform_remote_state.vpc.outputs.vpc_id
  public_subnets  = data.terraform_remote_state.vpc.outputs.public_subnets
  private_subnets = data.terraform_remote_state.vpc.outputs.private_subnets
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = local.remote_state_bucket
    region = local.remote_state_bucket_region
    key    = local.infrastructure_state_file
  }
}