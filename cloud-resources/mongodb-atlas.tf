variable "mongodbatlas_organization_id" {}
variable "mongodbatlas_public_key" {}
variable "mongodbatlas_private_key" {}
variable "mongodbatlas_chore_score_bot_user_password" {}

provider "mongodbatlas" {
  public_key  = var.mongodbatlas_public_key
  private_key = var.mongodbatlas_private_key
}

locals {
  mongodbatlas_cluster_name    = "crimson-cluster"
  mongodbatlas_serverless_name = "crimson-serverless"
}

# you can retrieve the base database uri by running `terraform output --raw crimson_cluster_uri`
output "crimson_cluster_uri" {
  value     = mongodbatlas_cluster.crimson_cluster.mongo_uri_with_options
  sensitive = true
}

# you can retrieve the base database uri by running `terraform output --raw crimson_serverless_uri`
output "crimson_serverless_uri" {
  value     = mongodbatlas_serverless_instance.crimson_serverless.connection_strings_standard_srv
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

resource "mongodbatlas_project_ip_access_list" "crimson_access_list" {
  project_id = mongodbatlas_project.crimson.id
  cidr_block = "0.0.0.0/0" # todo: only allow traffic from the k8s cluster
}

resource "mongodbatlas_cluster" "crimson_cluster" {
  project_id = mongodbatlas_project.crimson.id
  name       = local.mongodbatlas_cluster_name

  provider_name                = "TENANT"
  backing_provider_name        = "AZURE"
  provider_region_name         = "EUROPE_NORTH"
  provider_instance_size_name  = "M2"
  auto_scaling_compute_enabled = false

  lifecycle {
    prevent_destroy = false
  }
}

resource "mongodbatlas_serverless_instance" "crimson_serverless" {
  project_id = mongodbatlas_project.crimson.id
  name       = local.mongodbatlas_serverless_name

  provider_settings_backing_provider_name = "AZURE"
  provider_settings_region_name           = "EUROPE_WEST"
  provider_settings_provider_name         = "SERVERLESS"
  continuous_backup_enabled               = true
  termination_protection_enabled          = true

  lifecycle {
    prevent_destroy = true
  }
}

resource "mongodbatlas_database_user" "chore_score_bot_user" {
  username           = "chore-score-bot-user"
  password           = var.mongodbatlas_chore_score_bot_user_password
  project_id         = mongodbatlas_project.crimson.id
  auth_database_name = "admin"

  roles {
    role_name     = "dbAdmin"
    database_name = "chore-score-bot"
  }

  roles {
    role_name     = "readWrite"
    database_name = "chore-score-bot"
  }

  scopes {
    name = local.mongodbatlas_cluster_name
    type = "CLUSTER"
  }

  scopes {
    name = local.mongodbatlas_serverless_name
    type = "CLUSTER"
  }
}
