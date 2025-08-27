# helm install argocd -n argocd --create-namespace argo/argo-cd --version 3.35.4 -f terraform/values/argocd.yaml
resource "helm_release" "argocd" {
  name = "argocd"

  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
  version          = "7.3.11"

  values = [file("argocd/argocd.yaml")]
}

resource "helm_release" "bootstrap" {
  name       = "argocd-bootstrap"
  chart      = "./bootstrap"
  namespace  = "argocd"
  depends_on = [helm_release.argocd]
}