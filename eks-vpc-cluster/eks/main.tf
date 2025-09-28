data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "terraform-states"
    key    = "eks-vpc-cluster/vpc/terraform.tfstate"
    region = "eu-central-1"
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.29"
  cluster_endpoint_public_access = true

  vpc_id     = data.terraform_remote_state.vpc.outputs.vpc_id
  subnet_ids = concat(
    data.terraform_remote_state.vpc.outputs.private_subnets,
    data.terraform_remote_state.vpc.outputs.public_subnets
  )

  eks_managed_node_groups = {
    cpu-nodes = {
      desired_size = 2
      max_size     = 4
      min_size     = 1

      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"
    }

    gpu-nodes = {
      desired_size = 1
      max_size     = 2
      min_size     = 0

      instance_types = ["g4dn.xlarge"]
      capacity_type  = "ON_DEMAND"
    }
  }
}
