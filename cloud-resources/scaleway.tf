variable "scaleway_access_key" {}
variable "scaleway_secret_key" {}
variable "scaleway_project_id" {}
variable "indigo_db_admin_password" {}
variable "umami_db_user_password" {}

provider "scaleway" {
  zone       = "fr-par-1"
  region     = "fr-par"
  access_key = var.scaleway_access_key
  secret_key = var.scaleway_secret_key
  project_id = var.scaleway_project_id
}

resource "scaleway_rdb_instance" "indigo_db" {
  name              = "indigo"
  node_type         = "db-dev-s"
  engine            = "PostgreSQL-13"
  is_ha_cluster     = false
  disable_backup    = false
  volume_type       = "bssd"
  volume_size_in_gb = "5"
  user_name         = "admin"
  password          = var.indigo_db_admin_password
}

resource "scaleway_rdb_database" "umami_db" {
  instance_id = scaleway_rdb_instance.indigo_db.id
  name        = "umami"
}

# todo: for now, user permissions need to be assigned manually (via the scaleway
# web UI). the next provider version will allow us to achieve this via terraform
# instead, we should switch to doing that once the provider becomes available,
# see also: https://github.com/scaleway/terraform-provider-scaleway/pull/844
resource "scaleway_rdb_user" "umami_db_user" {
  instance_id = scaleway_rdb_instance.indigo_db.id
  name        = scaleway_rdb_database.umami_db.name
  password    = var.umami_db_user_password
  is_admin    = false
}
