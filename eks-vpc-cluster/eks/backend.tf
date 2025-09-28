terraform {
  backend "s3" {
    bucket         = "terraform-states"
    key            = "eks-vpc-cluster/eks/terraform.tfstate"
    region         = "eu-central-1"
    use_lockfile   = true
    encrypt        = true
  }
}
