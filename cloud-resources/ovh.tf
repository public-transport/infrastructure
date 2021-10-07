variable "ovh_application_key" {}
variable "ovh_application_secret" {}
variable "ovh_consumer_key" {}
variable "ovh_project_id" {}

# you can retrieve the kubeconfig file by running `terraform output --raw orchid_kubeconfig`
output "orchid_kubeconfig" {
  value     = ovh_cloud_project_kube.orchid_cluster.kubeconfig
  sensitive = true
}

provider "ovh" {
  endpoint           = "ovh-eu"
  application_key    = var.ovh_application_key
  application_secret = var.ovh_application_secret
  consumer_key       = var.ovh_consumer_key
}

resource "ovh_cloud_project_kube" "orchid_cluster" {
  service_name = var.ovh_project_id
  name         = "orchid"
  region       = "SBG5"
  version      = "1.22"
}

resource "ovh_cloud_project_kube_nodepool" "orchid_workers" {
  service_name   = var.ovh_project_id
  kube_id        = ovh_cloud_project_kube.orchid_cluster.id
  name           = "workers"
  flavor_name    = "d2-4"
  desired_nodes  = 1
  min_nodes      = 1
  max_nodes      = 1
  monthly_billed = false
  anti_affinity  = true
  autoscale      = false
}
