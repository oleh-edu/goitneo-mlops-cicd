variable "region" {
  default = "eu-central-1"
}

variable "profile" {
  default = "default"
}

variable "vpc_name" {
  default = "eks-vpc"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "azs" {
  default = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
}

variable "cluster_name" {
  default = "eks-cluster"
}
