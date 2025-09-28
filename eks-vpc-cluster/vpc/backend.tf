terraform {
  backend "s3" {
    bucket         = "terraform-states"
    key            = "eks-vpc-cluster/vpc/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
