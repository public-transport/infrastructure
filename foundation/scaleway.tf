variable "scaleway_access_key" {}
variable "scaleway_secret_key" {}
variable "scaleway_project_id" {}

# you can retrieve the kubeconfig file by running `terraform output --raw lilac_kubeconfig`
output "lilac_kubeconfig" {
  value     = scaleway_k8s_cluster.lilac.kubeconfig[0].config_file
  sensitive = true
}

provider "scaleway" {
  zone       = "fr-par-1"
  region     = "fr-par"
  access_key = var.scaleway_access_key
  secret_key = var.scaleway_secret_key
  project_id = var.scaleway_project_id
}

resource "scaleway_k8s_cluster" "lilac" {
  name    = "lilac"
  version = "1.22"
  cni     = "cilium"
  auto_upgrade {
    enable                        = true
    maintenance_window_start_hour = 2
    maintenance_window_day        = "any"
  }
}

resource "scaleway_k8s_pool" "lilac_workers" {
  cluster_id          = scaleway_k8s_cluster.lilac.id
  name                = "lilac_workers"
  node_type           = "DEV1-M"
  size                = 1
  autoscaling         = false
  autohealing         = true
  wait_for_pool_ready = true
}
