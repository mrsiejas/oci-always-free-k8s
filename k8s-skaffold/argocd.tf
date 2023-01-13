resource "helm_release" "argocd" {
  name = "argocd"

  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  version          = "5.16.13"
  create_namespace = true

  # @TODO: 
  # - verify insecure config map
  # - add domain name variable taken from tfvars via templatefile to ingress.yaml
  # - add application configuration for argocd so that Application is deployed via Terraform
  set {
    name  = "configs.params.server\\.insecure"
    value = "true"
  }

  #   values = [
  #     file("argocd/application.yaml")
  #   ]
}

