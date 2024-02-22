terraform {
  backend "remote" {
    organization = "public-transport"
    workspaces {
      name = "infrastructure"
    }
  }
  required_version = "~> 1.7"
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.34"
    }
    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
      version = "~> 1.15"
    }
    betteruptime = {
      source  = "BetterStackHQ/better-uptime"
      version = "~> 0.6"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.25"
    }
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45"
    }
    flux = {
      source  = "fluxcd/flux"
      version = "~> 1.2"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.6"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}
