variable "namespace" {
  type        = string
  default     = "infra-tools"
  description = "Namespace for ArgoCD"
}

variable "argo_cd_chart_version" {
  description = "argo-cd chart version from argo-helm repo"
  type        = string
  default     = "8.5.6"
}

variable "platform" {
  description = "Target platform: minikube or eks"
  type        = string
  default     = "minikube"
  validation {
    condition     = contains(["minikube", "eks"], var.platform)
    error_message = "platform must be 'minikube' or 'eks'."
  }
}

variable "kubeconfig_path" {
  description = "Path to kubeconfig (for minikube)"
  type        = string
  default     = "~/.kube/config"
}

variable "kube_context" {
  description = "Kube context name (for minikube)"
  type        = string
  default     = "minikube"
}

# EKS
variable "aws_region" {
  description = "AWS region for EKS"
  type        = string
  default     = "eu-central-1"
}

variable "eks_cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = null
}

variable "values_file" {
  description = "Optional Helm values file path"
  type        = string
  default     = null
}

