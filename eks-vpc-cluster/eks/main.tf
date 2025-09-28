module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.33"
  cluster_endpoint_public_access = true

  vpc_id     = var.vpc_id
  subnet_ids = concat(
    var.private_subnets,
    var.public_subnets
  )

  eks_managed_node_groups = {
    cpu-nodes = {
      desired_size = 1
      max_size     = 1
      min_size     = 1

      instance_types = ["t3.small"]
      capacity_type  = "ON_DEMAND"
    }

    # Uncomment only if GPU is required (will be expensive!)
    # gpu-nodes = {
    #  desired_size = 0
    #  max_size     = 1
    #  min_size     = 0
    #
    #  instance_types = ["g4dn.xlarge"]
    #  capacity_type  = "ON_DEMAND"
    # }
  }
}
