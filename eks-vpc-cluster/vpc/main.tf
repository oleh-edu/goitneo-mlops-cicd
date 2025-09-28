module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = var.vpc_name
  cidr = var.cidr

  azs             = var.azs
  private_subnets = [for i in range(length(var.azs)) : cidrsubnet(var.cidr, 4, i)]
  public_subnets  = [for i in range(length(var.azs)) : cidrsubnet(var.cidr, 8, i+100)]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
}
