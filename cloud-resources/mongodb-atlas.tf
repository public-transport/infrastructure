variable "mongodbatlas_organization_id" {}
variable "mongodbatlas_public_key" {}
variable "mongodbatlas_private_key" {}
variable "mongodbatlas_db_user_password" {}

provider "mongodbatlas" {
  public_key  = var.mongodbatlas_public_key
  private_key = var.mongodbatlas_private_key
}

locals {
  mongodbatlas_cluster_name = "crimson-cluster"
}

# you can retrieve the base database uri by running `terraform output --raw crimson_uri`
output "crimson_uri" {
  value     = mongodbatlas_cluster.crimson_cluster.mongo_uri_with_options
  sensitive = true
}

resource "mongodbatlas_project" "crimson" {
  name   = "crimson"
  org_id = var.mongodbatlas_organization_id

  lifecycle {
    prevent_destroy = true
  }
}

resource "mongodbatlas_maintenance_window" "crimson_maintenance_window" {
  project_id  = mongodbatlas_project.crimson.id
  hour_of_day = 4 # time in UTC
  day_of_week = 2 # monday
}

# todo: add ip allow-list here, and only allow traffic from the k8s cluster

resource "mongodbatlas_cluster" "crimson_cluster" {
  project_id = mongodbatlas_project.crimson.id
  name       = local.mongodbatlas_cluster_name

  provider_name                = "TENANT"
  backing_provider_name        = "AZURE"
  provider_region_name         = "EUROPE_WEST"
  provider_instance_size_name  = "M0"
  auto_scaling_compute_enabled = false

  lifecycle {
    prevent_destroy = true
  }
}

resource "mongodbatlas_database_user" "crimson_user" {
  username           = "crimson-user"
  password           = var.mongodbatlas_db_user_password
  project_id         = mongodbatlas_project.crimson.id
  auth_database_name = "admin"

  roles {
    role_name     = "dbAdmin"
    database_name = "example-database-todo"
  }

  scopes {
    name = local.mongodbatlas_cluster_name
    type = "CLUSTER"
  }
}
