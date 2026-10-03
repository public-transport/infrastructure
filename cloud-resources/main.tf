terraform {
  backend "remote" {
    organization = "public-transport"
    workspaces {
      name = "infrastructure"
    }
  }
  required_version = "~> 1.16"
  required_providers {
    betteruptime = {
      source  = "BetterStackHQ/better-uptime"
      version = "~> 0.20"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.52"
    }
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.69"
    }
    flux = {
      source  = "fluxcd/flux"
      version = "~> 1.9"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 3.3"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.13"
    }
  }
}
