variable "digitalocean_token" {}

provider "digitalocean" {
  token = var.digitalocean_token
}

resource "digitalocean_record" "prod_cluster_record" {
  domain = "public-transport.earth"
  type   = "A"
  name   = "prod.infra"
  value  = "51.91.26.140" # todo: create load balancer with terraform and reference its ip address here instead of hardcoding (currently not supported by ovh)
}

# todo: ipv6 once ovh or scaleway load balancers support it
