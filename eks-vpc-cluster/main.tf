provider "aws" {
  region = var.region
  profile = var.profile
}

module "vpc" {
  source = "./vpc"

  vpc_name = var.vpc_name
  cidr     = var.vpc_cidr
  azs      = var.azs
}

module "eks" {
  source = "./eks"

  cluster_name = var.cluster_name
  region       = var.region

  vpc_id             = module.vpc.vpc_id
  private_subnets    = module.vpc.private_subnets
  public_subnets     = module.vpc.public_subnets
}
