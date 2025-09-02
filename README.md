# Bootstrapping EKS cluster with ArgoCD

> Terraform stack for deploying an **Amazon EKS** cluster on AWS with supporting VPC/networking.  
> Once the cluster is up, **Argo CD + bootstrap Helm charts handle the rest** (monitoring, ingress, gateways, etc.).

---

## What This Provides

- **Networking**: VPC, subnets, IGW, NAT, route tables  
- **Cluster**: Amazon EKS control plane + managed node groups  
- **Bootstrap GitOps**:  
  - Argo CD deployment (GitOps controller)  
  - Bootstrap Helm chart that applies monitoring, Envoy Gateway, and other workloads automatically  

You do **not** need to apply individual Helm releases for Prometheus, Grafana, Envoy, etc. — they are handled by Argo CD once it syncs the bootstrap app.

---

## Prerequisites

- **AWS account** with permissions to create VPC/EKS/IAM/ELB/etc.  
- **CLI tools**:  
  - [Terraform](https://developer.hashicorp.com/terraform/downloads) (≥ 1.5 recommended)  
  - [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) (configured with `aws configure`)  
  - [kubectl](https://kubernetes.io/docs/tasks/tools/)  
- (Optional) [Helm](https://helm.sh/docs/intro/install/) for troubleshooting  

---

## Quick Start

1. **Clone the repo**
   ```bash
   git clone https://github.com/Class-6-Hungry-Wolves/anton-basic-eks-updated.git
   cd anton-basic-eks-updated
2. **Set variables**
   - Edit 0-var.tf to configure:
     - AWS region
     - Cluster name
     - VPC CIDRs, node types, counts, etc
  
3. **Iniialize Terraform**
   ```bash
    terraform init
    terraform validate
    terraform plan
    terraform apply
4. **Update kubeconfig**
   ```bash
   aws eks --region <region> update-kubeconfig --name <cluster-name> --profile <aws_profile>
   kubectl get nodes

---

## GitOps Flow
- Terraform only handles the infrastructure
- After the cluster is deployed, ArgoCD is installed with Helm
- After than the bootstrap app gets applied that deploys:
  - Prometheus + Grafana stack
  - Envoy Gateway
  - You can add more apps to be deployed in the bootstrap manifests folder

---

## Verification

1. **Check the components**
   ```bash
   kubectl get nodes
   kubectl get pods -A
2. **Check ArgoCD**
   ```bash
   kubectl -n argocd get pods
   kubectl -n argocd get svc
3. **Check Bootstrap workloads**
   - After boostrap, you should see the workloads in the argocd namespace
  
---

## Cleanup
1. **Destroy the Terraform stack**
   ```bash
   kubectl delete ns argocd
   terraform destroy
---