# EKS + VPC Terraform Project

## Steps

    cd eks-vpc-cluster/
    terraform init
    terraform apply

## After apply

    aws eks --region eu-central-1 update-kubeconfig --name eks-cluster
    kubectl get nodes
