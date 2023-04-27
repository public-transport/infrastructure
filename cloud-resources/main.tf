terraform {
  backend "remote" {
    organization = "public-transport"
    workspaces {
      name = "infrastructure"
    }
  }
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.25"
    }
    ovh = {
      source  = "ovh/ovh"
      version = "~> 0.26.0"
    }
    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
      version = "~> 1.6"
    }
    betteruptime = {
      source  = "BetterStackHQ/better-uptime"
      version = "~> 0.3.14"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.4.0"
    }
  }
}
