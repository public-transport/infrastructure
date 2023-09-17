variable "github_token" {}

provider "github" {
  owner = "public-transport"
  token = var.github_token
}

resource "tls_private_key" "flux_key" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "github_repository_deploy_key" "github_deploy_key_flux" {
  title      = "flux"
  repository = "infrastructure"
  key        = tls_private_key.flux_key.public_key_openssh
  read_only  = false
}
