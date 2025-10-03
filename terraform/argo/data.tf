data "aws_eks_cluster" "this" {
  count = var.platform == "eks" ? 1 : 0
  name  = var.eks_cluster_name
}

data "aws_eks_cluster_auth" "this" {
  count = var.platform == "eks" ? 1 : 0
  name  = var.eks_cluster_name
}
