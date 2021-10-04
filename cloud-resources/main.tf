terraform {
  backend "remote" {
    organization = "public-transport"
    workspaces {
      name = "infrastructure"
    }
  }
  required_providers {
    scaleway = {
      source = "scaleway/scaleway"
    }
  }
}
