output "argocd_namespace" {
  value = var.namespace
}

output "platform" {
  value = var.platform
}

output "server_service_type" {
  value = var.platform == "eks" ? "LoadBalancer" : "ClusterIP"
}
