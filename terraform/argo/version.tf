terraform {
  required_version = "~> 1.13"
  required_providers {
    helm       = { source = "hashicorp/helm", version = "~> 3.0.0" }
    kubernetes = { source = "hashicorp/kubernetes", version = "~> 2.38" }
    aws        = { source = "hashicorp/aws", version = "~> 5.0" }
  }
}