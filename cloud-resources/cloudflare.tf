variable "cloudflare_api_token" {}
variable "cloudflare_account_id" {}

locals {
  cluster_domain = "cluster.infra.public-transport.earth"
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

resource "cloudflare_zone" "railway_guru" {
  account_id = var.cloudflare_account_id
  zone = "railway.guru"
  jump_start = false
  paused = true
  plan = "free"
}

resource "cloudflare_zone" "umsteigen_jetzt" {
  account_id = var.cloudflare_account_id
  zone = "umsteigen.jetzt"
  jump_start = false
  paused = true
  plan = "free"
}

resource "cloudflare_zone" "pricemap_eu" {
  account_id = var.cloudflare_account_id
  zone = "pricemap.eu"
  jump_start = false
  paused = true
  plan = "free"
}

resource "cloudflare_record" "railway_guru_root" {
  zone_id = cloudflare_zone.railway_guru.id
  type = "CNAME"
  name = "@"
  value = local.cluster_domain
  proxied = true
}

resource "cloudflare_record" "railway_guru_subdomains" {
  zone_id = cloudflare_zone.railway_guru.id
  type = "CNAME"
  name = "*"
  value = local.cluster_domain
  proxied = true
}

resource "cloudflare_record" "umsteigen_jetzt_root" {
  zone_id = cloudflare_zone.umsteigen_jetzt.id
  type = "CNAME"
  name = "@"
  value = local.cluster_domain
  proxied = true
}

resource "cloudflare_record" "umsteigen_jetzt_subdomains" {
  zone_id = cloudflare_zone.umsteigen_jetzt.id
  type = "CNAME"
  name = "*"
  value = local.cluster_domain
  proxied = true
}

resource "cloudflare_record" "pricemap_eu_root" {
  zone_id = cloudflare_zone.pricemap_eu.id
  type = "CNAME"
  name = "@"
  value = local.cluster_domain
  proxied = true
}

resource "cloudflare_record" "pricemap_eu_subdomains" {
  zone_id = cloudflare_zone.pricemap_eu.id
  type = "CNAME"
  name = "*"
  value = local.cluster_domain
  proxied = true
}
