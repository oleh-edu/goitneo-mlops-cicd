resource "kubernetes_namespace" "infra_tools" {
  metadata {
    name = var.namespace
  }
}


resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.argo_cd_chart_version
  namespace  = kubernetes_namespace.infra_tools.metadata[0].name
  depends_on = [kubernetes_namespace.infra_tools]

  # install CRDs
  set = [{
    name  = "crds.install"
    value = "true"
  }, 
  {
    # EKS -> LoadBalancer, minikube -> ClusterIP
    name  = "server.service.type"
    value = var.platform == "eks" ? "LoadBalancer" : "ClusterIP"
  }]

  values     = var.values_file == null ? [] : [file("${path.module}/values/argocd-values.yaml")]
  wait            = true
  atomic          = true
  cleanup_on_fail = true
  recreate_pods   = false
  timeout         = 600
}
