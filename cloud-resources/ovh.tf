variable "ovh_application_key" {}
variable "ovh_application_secret" {}
variable "ovh_consumer_key" {}
variable "ovh_project_id" {}

provider "ovh" {
  endpoint           = "ovh-eu"
  application_key    = var.ovh_application_key
  application_secret = var.ovh_application_secret
  consumer_key       = var.ovh_consumer_key
}
