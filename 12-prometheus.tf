resource "helm_release" "prometheus" {
    depends_on = [aws_eks_node_group.private-nodes, null_resource.update_kubeconfig, helm_release.ebs_csi_driver ]
  name             = "prometheus"
  namespace        = "observability"
  create_namespace = true
  chart = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  version = "65.0.0"
  skip_crds = true 
  values = [
    file("./prometheus-notes/kube-prom-values.yaml")
  ]
}

#


