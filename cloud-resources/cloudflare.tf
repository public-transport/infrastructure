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
  account = {
    id = var.cloudflare_account_id
  }
  name   = "public-transport.earth"
  paused = true
}

resource "cloudflare_zone" "bahn_guru" {
  account = {
    id = var.cloudflare_account_id
  }
  name   = "bahn.guru"
  paused = true
}

resource "cloudflare_zone" "railway_guru" {
  account = {
    id = var.cloudflare_account_id
  }
  name   = "railway.guru"
  paused = true
}

resource "cloudflare_zone" "umsteigen_jetzt" {
  account = {
    id = var.cloudflare_account_id
  }
  name   = "umsteigen.jetzt"
  paused = true
}

resource "cloudflare_zone" "pricemap_eu" {
  account = {
    id = var.cloudflare_account_id
  }
  name   = "pricemap.eu"
  paused = true
}

# dnssec

resource "cloudflare_zone_dnssec" "public_transport_earth_dnssec" {
  zone_id = cloudflare_zone.public_transport_earth.id
  status  = "active"
}

resource "cloudflare_zone_dnssec" "bahn_guru_dnssec" {
  zone_id = cloudflare_zone.bahn_guru.id
  status  = "active"
}

resource "cloudflare_zone_dnssec" "railway_guru_dnssec" {
  zone_id = cloudflare_zone.railway_guru.id
  status  = "active"
}

resource "cloudflare_zone_dnssec" "umsteigen_jetzt_dnssec" {
  zone_id = cloudflare_zone.umsteigen_jetzt.id
  status  = "active"
}

resource "cloudflare_zone_dnssec" "pricemap_eu_dnssec" {
  zone_id = cloudflare_zone.pricemap_eu.id
  status  = "active"
}

# records for public-transport.earth

resource "cloudflare_dns_record" "public_transport_earth_legacy_cluster_v4" {
  zone_id = cloudflare_zone.public_transport_earth.id
  type    = "A"
  name    = "cluster.infra.public-transport.earth"
  content = module.kube-hetzner.ingress_public_ipv4
  proxied = true
  ttl     = 1
}

resource "cloudflare_dns_record" "public_transport_earth_legacy_cluster_v6" {
  zone_id = cloudflare_zone.public_transport_earth.id
  type    = "AAAA"
  name    = "cluster.infra.public-transport.earth"
  content = module.kube-hetzner.ingress_public_ipv6
  proxied = true
  ttl     = 1
}

resource "cloudflare_dns_record" "public_transport_earth_tilia_v4" {
  zone_id = cloudflare_zone.public_transport_earth.id
  type    = "A"
  name    = "tilia.cluster.infra.public-transport.earth"
  content = module.kube-hetzner.ingress_public_ipv4
  proxied = true
  ttl     = 1
}

resource "cloudflare_dns_record" "public_transport_earth_tilia_v6" {
  zone_id = cloudflare_zone.public_transport_earth.id
  type    = "AAAA"
  name    = "tilia.cluster.infra.public-transport.earth"
  content = module.kube-hetzner.ingress_public_ipv6
  proxied = true
  ttl     = 1
}

resource "cloudflare_dns_record" "public_transport_earth_example_app" {
  zone_id = cloudflare_zone.public_transport_earth.id
  type    = "CNAME"
  name    = "example.infra.public-transport.earth"
  content = local.tilia_cluster_domain
  proxied = true
  ttl     = 1
}

resource "cloudflare_dns_record" "public_transport_earth_eu_data" {
  zone_id = cloudflare_zone.public_transport_earth.id
  type    = "CNAME"
  name    = "eu.data.public-transport.earth"
  content = local.tilia_cluster_domain
  proxied = true
  ttl     = 1
}

resource "cloudflare_dns_record" "public_transport_earth_data" {
  zone_id = cloudflare_zone.public_transport_earth.id
  type    = "CNAME"
  name    = "data.public-transport.earth"
  content = local.tilia_cluster_domain
  proxied = true
  ttl     = 1
}

resource "cloudflare_dns_record" "public_transport_earth_de_data" {
  zone_id = cloudflare_zone.public_transport_earth.id
  type    = "CNAME"
  name    = "de.data.public-transport.earth"
  content = local.tilia_cluster_domain
  proxied = true
  ttl     = 1
}

resource "cloudflare_dns_record" "public_transport_earth_umami" {
  zone_id = cloudflare_zone.public_transport_earth.id
  type    = "CNAME"
  name    = "developer.public-transport.earth"
  content = local.tilia_cluster_domain
  proxied = true
  ttl     = 1
}

# records for bahn.guru

resource "cloudflare_dns_record" "bahn_guru_root" {
  zone_id = cloudflare_zone.bahn_guru.id
  type    = "CNAME"
  name    = "bahn.guru"
  content = local.tilia_cluster_domain
  proxied = true
  ttl     = 1
}

resource "cloudflare_dns_record" "bahn_guru_direkt" {
  zone_id = cloudflare_zone.bahn_guru.id
  type    = "CNAME"
  name    = "direkt.bahn.guru"
  content = "juliuste.github.io"
  proxied = true
  ttl     = 1
}

resource "cloudflare_dns_record" "bahn_guru_direkt_subdomains" {
  zone_id = cloudflare_zone.bahn_guru.id
  type    = "CNAME"
  name    = "*.direkt.bahn.guru"
  content = local.tilia_cluster_domain
  proxied = true
  ttl     = 1
}

resource "cloudflare_dns_record" "bahn_guru_beta" {
  zone_id = cloudflare_zone.bahn_guru.id
  type    = "CNAME"
  name    = "beta.bahn.guru"
  content = "cname.vercel-dns.com"
  proxied = true
  ttl     = 1
}

resource "cloudflare_dns_record" "bahn_guru_beta_subdomains" {
  zone_id = cloudflare_zone.bahn_guru.id
  type    = "CNAME"
  name    = "*.beta.bahn.guru"
  content = local.tilia_cluster_domain
  proxied = true
  ttl     = 1
}

resource "cloudflare_dns_record" "bahn_guru_developer" {
  zone_id = cloudflare_zone.bahn_guru.id
  type    = "CNAME"
  name    = "developer.bahn.guru"
  content = local.tilia_cluster_domain
  proxied = true
  ttl     = 1
}

resource "cloudflare_dns_record" "bahn_guru_subdomains" {
  zone_id = cloudflare_zone.bahn_guru.id
  type    = "CNAME"
  name    = "*.bahn.guru"
  content = local.tilia_cluster_domain
  proxied = true
  ttl     = 1
}

# records for railway.guru

resource "cloudflare_dns_record" "railway_guru_root" {
  zone_id = cloudflare_zone.railway_guru.id
  type    = "CNAME"
  name    = "railway.guru"
  content = local.tilia_cluster_domain
  proxied = true
  ttl     = 1
}

resource "cloudflare_dns_record" "railway_guru_subdomains" {
  zone_id = cloudflare_zone.railway_guru.id
  type    = "CNAME"
  name    = "*.railway.guru"
  content = local.tilia_cluster_domain
  proxied = true
  ttl     = 1
}

# records for umsteigen.jetzt

resource "cloudflare_dns_record" "umsteigen_jetzt_root" {
  zone_id = cloudflare_zone.umsteigen_jetzt.id
  type    = "CNAME"
  name    = "umsteigen.jetzt"
  content = local.tilia_cluster_domain
  proxied = true
  ttl     = 1
}

resource "cloudflare_dns_record" "umsteigen_jetzt_subdomains" {
  zone_id = cloudflare_zone.umsteigen_jetzt.id
  type    = "CNAME"
  name    = "*.umsteigen.jetzt"
  content = local.tilia_cluster_domain
  proxied = true
  ttl     = 1
}

# records for pricemap.eu

resource "cloudflare_dns_record" "pricemap_eu_root" {
  zone_id = cloudflare_zone.pricemap_eu.id
  type    = "CNAME"
  name    = "pricemap.eu"
  content = local.tilia_cluster_domain
  proxied = true
  ttl     = 1
}

resource "cloudflare_dns_record" "pricemap_eu_subdomains" {
  zone_id = cloudflare_zone.pricemap_eu.id
  type    = "CNAME"
  name    = "*.pricemap.eu"
  content = local.tilia_cluster_domain
  proxied = true
  ttl     = 1
}

# provider v5 migration, remove after apply

moved {
  from = cloudflare_record.public_transport_earth_legacy_cluster_v4
  to   = cloudflare_dns_record.public_transport_earth_legacy_cluster_v4
}

moved {
  from = cloudflare_record.public_transport_earth_legacy_cluster_v6
  to   = cloudflare_dns_record.public_transport_earth_legacy_cluster_v6
}

moved {
  from = cloudflare_record.public_transport_earth_tilia_v4
  to   = cloudflare_dns_record.public_transport_earth_tilia_v4
}

moved {
  from = cloudflare_record.public_transport_earth_tilia_v6
  to   = cloudflare_dns_record.public_transport_earth_tilia_v6
}

moved {
  from = cloudflare_record.public_transport_earth_example_app
  to   = cloudflare_dns_record.public_transport_earth_example_app
}

moved {
  from = cloudflare_record.public_transport_earth_eu_data
  to   = cloudflare_dns_record.public_transport_earth_eu_data
}

moved {
  from = cloudflare_record.public_transport_earth_data
  to   = cloudflare_dns_record.public_transport_earth_data
}

moved {
  from = cloudflare_record.public_transport_earth_de_data
  to   = cloudflare_dns_record.public_transport_earth_de_data
}

moved {
  from = cloudflare_record.public_transport_earth_umami
  to   = cloudflare_dns_record.public_transport_earth_umami
}

moved {
  from = cloudflare_record.bahn_guru_root
  to   = cloudflare_dns_record.bahn_guru_root
}

moved {
  from = cloudflare_record.bahn_guru_direkt
  to   = cloudflare_dns_record.bahn_guru_direkt
}

moved {
  from = cloudflare_record.bahn_guru_direkt_subdomains
  to   = cloudflare_dns_record.bahn_guru_direkt_subdomains
}

moved {
  from = cloudflare_record.bahn_guru_beta
  to   = cloudflare_dns_record.bahn_guru_beta
}

moved {
  from = cloudflare_record.bahn_guru_beta_subdomains
  to   = cloudflare_dns_record.bahn_guru_beta_subdomains
}

moved {
  from = cloudflare_record.bahn_guru_developer
  to   = cloudflare_dns_record.bahn_guru_developer
}

moved {
  from = cloudflare_record.bahn_guru_subdomains
  to   = cloudflare_dns_record.bahn_guru_subdomains
}

moved {
  from = cloudflare_record.railway_guru_root
  to   = cloudflare_dns_record.railway_guru_root
}

moved {
  from = cloudflare_record.railway_guru_subdomains
  to   = cloudflare_dns_record.railway_guru_subdomains
}

moved {
  from = cloudflare_record.umsteigen_jetzt_root
  to   = cloudflare_dns_record.umsteigen_jetzt_root
}

moved {
  from = cloudflare_record.umsteigen_jetzt_subdomains
  to   = cloudflare_dns_record.umsteigen_jetzt_subdomains
}

moved {
  from = cloudflare_record.pricemap_eu_root
  to   = cloudflare_dns_record.pricemap_eu_root
}

moved {
  from = cloudflare_record.pricemap_eu_subdomains
  to   = cloudflare_dns_record.pricemap_eu_subdomains
}
