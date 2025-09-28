# EKS + VPC Terraform Project

This project demonstrates how to build AWS infrastructure with Terraform:

- **VPC** using [terraform-aws-modules/vpc/aws](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest)
- **EKS cluster** using [terraform-aws-modules/eks/aws](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest)
- Two node groups: `cpu-nodes` and `gpu-nodes`

---

## 📦 Project Structure

    eks-vpc-cluster/
    ├── main.tf          # imports vpc/ and eks/ modules
    ├── variables.tf
    ├── outputs.tf
    ├── terraform.tf
    ├── backend.tf       # backend (local or S3)
    ├── vpc/
    │   ├── main.tf
    │   ├── variables.tf
    │   ├── outputs.tf
    │   └── terraform.tf
    └── eks/
        ├── main.tf
        ├── variables.tf
        ├── outputs.tf
        └── terraform.tf

---

## 🚀 Execution Modes

### 1. Mono-state (recommended for this homework)

- The whole project is managed with **a single state**.
- Backend (S3 or local) is declared only in `eks-vpc-cluster/backend.tf`.
- `./vpc` and `./eks` are local modules.
- Everything is applied with a single `terraform apply`.

### 2. Multi-state (advanced option)

- `vpc/` and `eks/` have separate backends (different state files).
- Infrastructure is applied separately in two steps.
- In `eks/main.tf`, VPC data is pulled with `data "terraform_remote_state"`.
- Useful for large teams where different infra parts are managed independently.

---

## ⚙️ Prerequisites

1. Install [Terraform](https://developer.hashicorp.com/terraform/downloads)
2. Install [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
3. Configure AWS credentials:
   aws configure

   or via SSO:

   aws sso login --profile my-profile

---

## ▶️ Deployment Steps (Mono-state)

    cd eks-vpc-cluster/

    terraform init -reconfigure
    terraform validate
    terraform plan
    terraform apply

This will create:

- A VPC with public and private subnets
- An EKS cluster
- Two node groups (`cpu-nodes`, `gpu-nodes`)

---

## 📡 After Apply

Update kubeconfig:

    aws eks --region eu-central-1 update-kubeconfig --name eks-cluster

Check nodes:

    kubectl get nodes

You should see both node groups (`cpu-nodes`, `gpu-nodes`).

---

## 🧹 Destroying Infrastructure

    terraform destroy

⚠️ This will remove the entire infrastructure (cluster, VPC, nodes).

---

## 💡 Troubleshooting

- **Warning: Backend configuration ignored**
  Remove `backend.tf` from `eks/` and `vpc/`.
  Backend should only be defined in the root module.

- **InvalidClientTokenId**
  Check AWS credentials:

  aws sts get-caller-identity

- **Plugin cache error**
  Create plugin cache directory:

  mkdir -p ~/.terraform.d/plugin-cache

---

## 📖 Useful Links

- [terraform-aws-modules/vpc/aws](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest)
- [terraform-aws-modules/eks/aws](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest)
- [AWS EKS Documentation](https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html)
