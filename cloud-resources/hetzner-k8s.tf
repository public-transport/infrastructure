variable "hetzner_cloud_token" {}
variable "hetzner_k8s_ssh_public" {}
variable "hetzner_k8s_ssh_private" {}

provider "hcloud" {
  token = var.hetzner_cloud_token
}

output "tilia_kubeconfig" {
  value     = module.kube-hetzner.kubeconfig
  sensitive = true
}

module "kube-hetzner" {
  providers            = { hcloud = hcloud }
  hcloud_token         = var.hetzner_cloud_token
  source               = "kube-hetzner/kube-hetzner/hcloud"
  version              = "v2.18.4"
  create_kustomization = false
  create_kubeconfig    = false

  ssh_public_key  = var.hetzner_k8s_ssh_public
  ssh_private_key = var.hetzner_k8s_ssh_private

  network_region = "eu-central"

  initial_k3s_channel = "stable"

  allow_scheduling_on_control_plane = true
  system_upgrade_enable_eviction    = false

  control_plane_nodepools = [{
    name        = "control-and-agent-v3",
    server_type = "cax21",
    location    = "fsn1",
    labels      = [],
    taints      = [],
    count       = 3
  }]
  agent_nodepools = [{
    name        = "agent",
    server_type = "cax21",
    location    = "fsn1",
    labels      = [],
    taints      = [],
    count       = 0
  }]

  enable_wireguard = true

  load_balancer_type     = "lb11"
  load_balancer_location = "fsn1"

  restrict_outbound_traffic = false

  # firewall_kube_api_source = null
  # firewall_ssh_source = null
}
