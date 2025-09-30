# ArgoCD Deployment via Terraform

This module deploys **ArgoCD** into an existing EKS cluster using the official Helm chart.

---

## 📂 Structure

```bash
terraform/argocd/
├── main.tf
├── variables.tf
├── provider.tf
├── outputs.tf
├── backend.tf
└── values/
    └── argocd-values.yaml
```

---

## ⚙️ Prerequisites

- An AWS EKS cluster is already created and accessible in `~/.kube/config`.
- An S3 bucket `goitneo-oleg-terraform-states` exists for Terraform state storage.
- (Recommended) A DynamoDB table for state locking.

---

## 🚀 Deploy ArgoCD

Initialize and apply Terraform:

```bash
cd terraform/argocd

terraform init
terraform validate
terraform apply
```

---

## 🔎 Verification

Check that ArgoCD pods are running:

```bash
kubectl get pods -n infra-tools
```

You should see several pods with the prefix `argocd-`.

---

## 🌐 Access ArgoCD UI

After deployment, a **LoadBalancer service** will be created.

1. Get the external IP address:

   ```bash
   kubectl get svc argocd-server -n infra-tools
   ```

2. Open in your browser:

   ```bash
   https://<EXTERNAL-IP>
   ```

3. Retrieve the initial admin password:

   ```bash
   kubectl -n infra-tools get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
   ```

4. Login:
   - **username:** `admin`
   - **password:** the value from the previous step

---

## 📦 values/argocd-values.yaml

Minimal configuration for ArgoCD:

```yaml
server:
  service:
    type: LoadBalancer
  ingress:
    enabled: false

controller:
  replicas: 1

repoServer:
  replicas: 1

dex:
  enabled: false

redis:
  enabled: true
```

---

## ✅ Expected outcome

- Namespace **infra-tools** is created in the EKS cluster.
- ArgoCD pods (`argocd-*`) are running.
- ArgoCD UI is accessible via LoadBalancer service.
