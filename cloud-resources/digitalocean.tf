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

resource "digitalocean_record" "european_transport_feeds_website_record" {
  domain = "public-transport.earth"
  type   = "CNAME"
  name   = "eu.data"
  value  = "${digitalocean_record.cluster_record.fqdn}."
}

resource "digitalocean_record" "european_transport_feeds_data_record" {
  domain = "public-transport.earth"
  type   = "CNAME"
  name   = "data"
  value  = "${digitalocean_record.cluster_record.fqdn}."
}

resource "digitalocean_record" "public_transport_data_scraper_legacy_proxy_record" {
  domain = "public-transport.earth"
  type   = "CNAME"
  name   = "de.data"
  value  = "${digitalocean_record.cluster_record.fqdn}."
}

resource "digitalocean_record" "umami_record" {
  domain = "public-transport.earth"
  type   = "CNAME"
  name   = "developer"
  value  = "${digitalocean_record.cluster_record.fqdn}."
}
