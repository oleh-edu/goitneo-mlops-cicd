terraform {
  backend "s3" {
    bucket         = "goitneo-oleg-terraform-states"
    key            = "eks-vpc-cluster/terraform.tfstate"
    region         = "eu-central-1"
    use_lockfile   = true
    encrypt        = true
  }
}

/*
terraform {
  backend "local" {
    path = "./terraform.tfstate"
  }
}
*/