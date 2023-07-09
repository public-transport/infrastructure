variable "cloudflare_api_token" {}
variable "cloudflare_account_id" {}

locals {
  cluster_domain = "cluster.infra.public-transport.earth"
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

# zones

resource "cloudflare_zone" "bahn_guru" {
  account_id = var.cloudflare_account_id
  zone = "bahn.guru"
  jump_start = false
  paused = true
  plan = "free"
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

# dnssec

resource "cloudflare_zone_dnssec" "bahn_guru_dnssec" {
  zone_id = cloudflare_zone.bahn_guru.id
}

resource "cloudflare_zone_dnssec" "railway_guru_dnssec" {
  zone_id = cloudflare_zone.railway_guru.id
}

resource "cloudflare_zone_dnssec" "umsteigen_jetzt_dnssec" {
  zone_id = cloudflare_zone.umsteigen_jetzt.id
}

resource "cloudflare_zone_dnssec" "pricemap_eu_dnssec" {
  zone_id = cloudflare_zone.pricemap_eu.id
}

# records for bahn.guru

resource "cloudflare_record" "bahn_guru_root" {
  zone_id = cloudflare_zone.bahn_guru.id
  type = "CNAME"
  name = "@"
  value = local.cluster_domain
  proxied = true
}

resource "cloudflare_record" "bahn_guru_direkt" {
  zone_id = cloudflare_zone.bahn_guru.id
  type = "CNAME"
  name = "direkt"
  value = "juliuste.github.io"
  proxied = true
}

resource "cloudflare_record" "bahn_guru_direkt_subdomains" {
  zone_id = cloudflare_zone.bahn_guru.id
  type = "CNAME"
  name = "*.direkt"
  value = local.cluster_domain
  proxied = true
}

resource "cloudflare_record" "bahn_guru_beta" {
  zone_id = cloudflare_zone.bahn_guru.id
  type = "CNAME"
  name = "beta"
  value = "cname.vercel-dns.com"
  proxied = true
}

resource "cloudflare_record" "bahn_guru_beta_subdomains" {
  zone_id = cloudflare_zone.bahn_guru.id
  type = "CNAME"
  name = "*.beta"
  value = local.cluster_domain
  proxied = true
}

resource "cloudflare_record" "bahn_guru_subdomains" {
  zone_id = cloudflare_zone.bahn_guru.id
  type = "CNAME"
  name = "*"
  value = local.cluster_domain
  proxied = true
}

# records for railway.guru

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

# records for umsteigen.jetzt

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

# records for pricemap.eu

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
