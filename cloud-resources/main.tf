terraform {
  backend "remote" {
    organization = "public-transport"
    workspaces {
      name = "infrastructure"
    }
  }
  required_providers {
    ovh = {
      source = "ovh/ovh"
    }
  }
}
