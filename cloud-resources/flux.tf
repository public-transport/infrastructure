variable "flux_encryption_private_key" {}

provider "flux" {
  kubernetes = {
    host                   = module.kube-hetzner.kubeconfig_data.host
    client_certificate     = module.kube-hetzner.kubeconfig_data.client_certificate
    client_key             = module.kube-hetzner.kubeconfig_data.client_key
    cluster_ca_certificate = module.kube-hetzner.kubeconfig_data.cluster_ca_certificate
  }
  git = {
    url = "ssh://git@github.com/public-transport/infrastructure.git"
    ssh = {
      username    = "git"
      private_key = tls_private_key.flux_key.private_key_pem
    }
  }
}

provider "kubernetes" {
  host                   = module.kube-hetzner.kubeconfig_data.host
  client_certificate     = module.kube-hetzner.kubeconfig_data.client_certificate
  client_key             = module.kube-hetzner.kubeconfig_data.client_key
  cluster_ca_certificate = module.kube-hetzner.kubeconfig_data.cluster_ca_certificate
}

# resource "flux_bootstrap_git" "flux_tilia" {
#   depends_on       = [github_repository_deploy_key.github_deploy_key_flux]
#   path             = "kubernetes/clusters/tilia"
#   components_extra = ["image-reflector-controller", "image-automation-controller"]
# }

# resource "kubernetes_secret" "flux_encryption_key" {
#   depends_on = [flux_bootstrap_git.flux_tilia]
#   metadata {
#     name      = "sops-gpg"
#     namespace = "flux-system"
#   }
#   data = {
#     "sops.asc" = var.flux_encryption_private_key
#   }
# }
