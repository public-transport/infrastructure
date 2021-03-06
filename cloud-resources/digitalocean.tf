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

resource "digitalocean_record" "bahn_guru_record" {
  domain = "bahn.guru"
  type   = "A"
  name   = "@"
  value  = "51.91.81.181" # todo: create load balancer with terraform and reference its ip address here instead of hardcoding (currently not supported by ovh)
}

resource "digitalocean_record" "www_bahn_guru_record" {
  domain = "bahn.guru"
  type   = "CNAME"
  name   = "www"
  value  = "${digitalocean_record.cluster_record.fqdn}."
}

resource "digitalocean_record" "link_bahn_guru_record" {
  domain = "bahn.guru"
  type   = "CNAME"
  name   = "link"
  value  = "${digitalocean_record.cluster_record.fqdn}."
}

resource "digitalocean_record" "bus_bahn_guru_record" {
  domain = "bahn.guru"
  type   = "CNAME"
  name   = "bus"
  value  = "${digitalocean_record.cluster_record.fqdn}."
}

resource "digitalocean_record" "beta_bahn_guru_record" {
  domain = "bahn.guru"
  type   = "CNAME"
  name   = "beta"
  value  = "cname.vercel-dns.com."
}

resource "digitalocean_record" "direkt_bahn_guru_record" {
  domain = "bahn.guru"
  type   = "CNAME"
  name   = "direkt"
  value  = "juliuste.github.io."
}

resource "digitalocean_record" "api_direkt_bahn_guru_record" {
  domain = "bahn.guru"
  type   = "CNAME"
  name   = "api.direkt"
  value  = "${digitalocean_record.cluster_record.fqdn}."
}

resource "digitalocean_record" "umami_bahn_guru_record" {
  domain = "bahn.guru"
  type   = "CNAME"
  name   = "developer"
  value  = "${digitalocean_record.cluster_record.fqdn}."
}
