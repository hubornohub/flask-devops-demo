resource "digitalocean_kubernetes_cluster" "main" {
  name    = var.cluster_name
  region  = var.region
  version = "1.29.1-do.0"

  node_pool {
    name       = "default-pool"
    size       = "s-2vcpu-2gb"
    node_count = 1
  }
}

resource "digitalocean_container_registry" "main" {
  name = var.registry_name
  subscription_tier_slug = "starter"
}