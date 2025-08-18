terraform {
  backend "remote" {
    organization = "public-transport"
    workspaces {
      name = "infrastructure"
    }
  }
  required_version = "~> 1.12"
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.42"
    }
    betteruptime = {
      source  = "BetterStackHQ/better-uptime"
      version = "~> 0.20"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.42"
    }
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.52"
    }
    flux = {
      source  = "fluxcd/flux"
      version = "~> 1.4"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.38"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.6"
    }
  }
}
