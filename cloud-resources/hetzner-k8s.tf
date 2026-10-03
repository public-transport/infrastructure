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
  version              = "3.2.1"
  create_kustomization = false
  create_kubeconfig    = false

  ssh_public_key  = var.hetzner_k8s_ssh_public
  ssh_private_key = var.hetzner_k8s_ssh_private

  network_region = "eu-central"

  k3s_channel = "stable"

  # pinned to the versions running before the v3 upgrade, v3 would otherwise downgrade them
  hetzner_ccm_version  = "1.38.0"
  hetzner_csi_version  = "2.23.0"
  traefik_version      = "41.1.1"
  cert_manager_version = "v1.21.2"

  # let kured reboot nodes one by one instead of restarting k3s everywhere at once (etcd quorum)
  kubernetes_config_updates_use_kured_sentinel = true

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

  enable_cni_wireguard_encryption = true

  load_balancer_type     = "lb11"
  load_balancer_location = "fsn1"

  restrict_outbound_traffic = false
  allow_inbound_icmp        = true

  # firewall_kube_api_source = null
  # firewall_ssh_source = null
}
