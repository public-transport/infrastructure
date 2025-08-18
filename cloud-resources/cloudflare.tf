variable "cloudflare_api_token" {}
variable "cloudflare_account_id" {}

locals {
  tilia_cluster_domain = "tilia.cluster.infra.public-transport.earth"
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

# zones

resource "cloudflare_zone" "public_transport_earth" {
  account_id = var.cloudflare_account_id
  zone       = "public-transport.earth"
  jump_start = false
  paused     = true
  plan       = "free"
}

resource "cloudflare_zone" "bahn_guru" {
  account_id = var.cloudflare_account_id
  zone       = "bahn.guru"
  jump_start = false
  paused     = true
  plan       = "free"
}

resource "cloudflare_zone" "railway_guru" {
  account_id = var.cloudflare_account_id
  zone       = "railway.guru"
  jump_start = false
  paused     = true
  plan       = "free"
}

resource "cloudflare_zone" "umsteigen_jetzt" {
  account_id = var.cloudflare_account_id
  zone       = "umsteigen.jetzt"
  jump_start = false
  paused     = true
  plan       = "free"
}

resource "cloudflare_zone" "pricemap_eu" {
  account_id = var.cloudflare_account_id
  zone       = "pricemap.eu"
  jump_start = false
  paused     = true
  plan       = "free"
}

# dnssec

resource "cloudflare_zone_dnssec" "public_transport_earth_dnssec" {
  zone_id = cloudflare_zone.public_transport_earth.id
}

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

# records for public-transport.earth

# resource "cloudflare_record" "public_transport_earth_legacy_cluster_v4" {
#   zone_id = cloudflare_zone.public_transport_earth.id
#   type    = "A"
#   name    = "cluster.infra"
#   value   = module.kube-hetzner.ingress_public_ipv4
#   proxied = true
# }

# resource "cloudflare_record" "public_transport_earth_legacy_cluster_v6" {
#   zone_id = cloudflare_zone.public_transport_earth.id
#   type    = "AAAA"
#   name    = "cluster.infra"
#   value   = module.kube-hetzner.ingress_public_ipv6
#   proxied = true
# }

# resource "cloudflare_record" "public_transport_earth_tilia_v4" {
#   zone_id = cloudflare_zone.public_transport_earth.id
#   type    = "A"
#   name    = "tilia.cluster.infra"
#   value   = module.kube-hetzner.ingress_public_ipv4
#   proxied = true
# }

# resource "cloudflare_record" "public_transport_earth_tilia_v6" {
#   zone_id = cloudflare_zone.public_transport_earth.id
#   type    = "AAAA"
#   name    = "tilia.cluster.infra"
#   value   = module.kube-hetzner.ingress_public_ipv6
#   proxied = true
# }

resource "cloudflare_record" "public_transport_earth_example_app" {
  zone_id = cloudflare_zone.public_transport_earth.id
  type    = "CNAME"
  name    = "example.infra"
  value   = local.tilia_cluster_domain
  proxied = true
}

resource "cloudflare_record" "public_transport_earth_eu_data" {
  zone_id = cloudflare_zone.public_transport_earth.id
  type    = "CNAME"
  name    = "eu.data"
  value   = local.tilia_cluster_domain
  proxied = true
}

resource "cloudflare_record" "public_transport_earth_data" {
  zone_id = cloudflare_zone.public_transport_earth.id
  type    = "CNAME"
  name    = "data"
  value   = local.tilia_cluster_domain
  proxied = true
}

resource "cloudflare_record" "public_transport_earth_de_data" {
  zone_id = cloudflare_zone.public_transport_earth.id
  type    = "CNAME"
  name    = "de.data"
  value   = local.tilia_cluster_domain
  proxied = true
}

resource "cloudflare_record" "public_transport_earth_umami" {
  zone_id = cloudflare_zone.public_transport_earth.id
  type    = "CNAME"
  name    = "developer"
  value   = local.tilia_cluster_domain
  proxied = true
}

# records for bahn.guru

resource "cloudflare_record" "bahn_guru_root" {
  zone_id = cloudflare_zone.bahn_guru.id
  type    = "CNAME"
  name    = "@"
  value   = local.tilia_cluster_domain
  proxied = true
}

resource "cloudflare_record" "bahn_guru_direkt" {
  zone_id = cloudflare_zone.bahn_guru.id
  type    = "CNAME"
  name    = "direkt"
  value   = "juliuste.github.io"
  proxied = true
}

resource "cloudflare_record" "bahn_guru_direkt_subdomains" {
  zone_id = cloudflare_zone.bahn_guru.id
  type    = "CNAME"
  name    = "*.direkt"
  value   = local.tilia_cluster_domain
  proxied = true
}

resource "cloudflare_record" "bahn_guru_beta" {
  zone_id = cloudflare_zone.bahn_guru.id
  type    = "CNAME"
  name    = "beta"
  value   = "cname.vercel-dns.com"
  proxied = true
}

resource "cloudflare_record" "bahn_guru_beta_subdomains" {
  zone_id = cloudflare_zone.bahn_guru.id
  type    = "CNAME"
  name    = "*.beta"
  value   = local.tilia_cluster_domain
  proxied = true
}

resource "cloudflare_record" "bahn_guru_developer" {
  zone_id = cloudflare_zone.bahn_guru.id
  type    = "CNAME"
  name    = "developer"
  value   = local.tilia_cluster_domain
  proxied = true
}

resource "cloudflare_record" "bahn_guru_subdomains" {
  zone_id = cloudflare_zone.bahn_guru.id
  type    = "CNAME"
  name    = "*"
  value   = local.tilia_cluster_domain
  proxied = true
}

# records for railway.guru

resource "cloudflare_record" "railway_guru_root" {
  zone_id = cloudflare_zone.railway_guru.id
  type    = "CNAME"
  name    = "@"
  value   = local.tilia_cluster_domain
  proxied = true
}

resource "cloudflare_record" "railway_guru_subdomains" {
  zone_id = cloudflare_zone.railway_guru.id
  type    = "CNAME"
  name    = "*"
  value   = local.tilia_cluster_domain
  proxied = true
}

# records for umsteigen.jetzt

resource "cloudflare_record" "umsteigen_jetzt_root" {
  zone_id = cloudflare_zone.umsteigen_jetzt.id
  type    = "CNAME"
  name    = "@"
  value   = local.tilia_cluster_domain
  proxied = true
}

resource "cloudflare_record" "umsteigen_jetzt_subdomains" {
  zone_id = cloudflare_zone.umsteigen_jetzt.id
  type    = "CNAME"
  name    = "*"
  value   = local.tilia_cluster_domain
  proxied = true
}

# records for pricemap.eu

resource "cloudflare_record" "pricemap_eu_root" {
  zone_id = cloudflare_zone.pricemap_eu.id
  type    = "CNAME"
  name    = "@"
  value   = local.tilia_cluster_domain
  proxied = true
}

resource "cloudflare_record" "pricemap_eu_subdomains" {
  zone_id = cloudflare_zone.pricemap_eu.id
  type    = "CNAME"
  name    = "*"
  value   = local.tilia_cluster_domain
  proxied = true
}
