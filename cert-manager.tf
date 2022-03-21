resource "helm_release" "cert-manager" {
  name             = "cert-manager"
  namespace        = "cert-manager"
  create_namespace = true
  chart            = "cert-manager"
  cleanup_on_fail  = true
  repository       = "https://charts.jetstack.io"
  version          = "v1.7.1"
  set {
    name  = "ingressShim.defaultIssuerName"
    value = "letsencrypt-prod"
  }

  set {
    name  = "ingressShim.defaultIssuerKind"
    value = "ClusterIssuer"
  }

  set {
    name  = "ingressShim.defaultIssuerGroup"
    value = "cert-manager.io"
  }
  set {
    name  = "installCRDs"
    value = "true"
  }
}

resource "helm_release" "ingress-nginx" {
  name             = "ingress-nginx"
  namespace        = "ingress-nginx"
  create_namespace = true
  chart            = "ingress-nginx"
  cleanup_on_fail  = true
  repository       = "https://kubernetes.github.io/ingress-nginx"
}

# resource "kubectl_manifest" "test" {
#     yaml_body = <<YAML
# apiVersion: cert-manager.io/v1
# kind: ClusterIssuer
# metadata:
#   name: letsencrypt-staging
# spec:
#   acme:
#     server: https://acme-staging-v02.api.letsencrypt.org/directory
#     email: raviteja1804@gmail.com
#     privateKeySecretRef:
#       name: letsencrypt-staging
#     solvers:
#       - http01:
#           ingress:
#             class: nginx
# YAML
#   depends_on = [
#     helm_release.cert-manager,
#   ]
# }

