locals {
  # For EKS, take endpoint/ca/token; for minikube, use kubeconfig/context.
  host       = var.platform == "eks" ? data.aws_eks_cluster.this[0].endpoint : null
  cluster_ca = var.platform == "eks" ? base64decode(data.aws_eks_cluster.this[0].certificate_authority[0].data) : null
  token      = var.platform == "eks" ? data.aws_eks_cluster_auth.this[0].token : null

  kubeconfig  = var.platform == "minikube" ? pathexpand(var.kubeconfig_path) : null
  kubecontext = var.platform == "minikube" ? var.kube_context : null
}

provider "aws" {
  region = var.aws_region
}

provider "kubernetes" {
  host                   = local.host
  token                  = local.token
  cluster_ca_certificate = local.cluster_ca

  config_path    = local.kubeconfig
  config_context = local.kubecontext
}

provider "helm" {
  kubernetes = {
    host                   = local.host
    token                  = local.token
    cluster_ca_certificate = local.cluster_ca

    config_path    = local.kubeconfig
    config_context = local.kubecontext
  }
}
