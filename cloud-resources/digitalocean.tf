variable "digitalocean_token" {}

provider "digitalocean" {
  token = var.digitalocean_token
}

# basic infrastructure

resource "digitalocean_record" "cluster_record" {
  domain = "public-transport.earth"
  type   = "A"
  name   = "cluster.infra"
  value  = "51.91.81.181" # todo: create load balancer with terraform and reference its ip address here instead of hardcoding (currently not supported by ovh)
}

# todo: ipv6 once ovh or scaleway load balancers support it

# apps

resource "digitalocean_record" "example_app_record" {
  domain = "public-transport.earth"
  type   = "CNAME"
  name   = "example.infra"
  value  = "${digitalocean_record.cluster_record.fqdn}."
}

resource "digitalocean_record" "bus_bahn_guru_record" {
  domain = "bahn.guru"
  type   = "CNAME"
  name   = "bus"
  value  = "${digitalocean_record.cluster_record.fqdn}."
}

resource "digitalocean_record" "api_direkt_bahn_guru_record" {
  domain = "bahn.guru"
  type   = "CNAME"
  name   = "api.direkt"
  value  = "${digitalocean_record.cluster_record.fqdn}."
}
