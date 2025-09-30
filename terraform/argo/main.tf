provider "helm" {
  # No attributes needed here for kubeconfig path
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "infra_tools" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = kubernetes_namespace.infra_tools.metadata[0].name
  version    = "6.7.12" # current on ArtifactHub
  values     = [file("${path.module}/values/argocd-values.yaml")]
}
