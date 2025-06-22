output "kubeconfig" {
  value     = digitalocean_kubernetes_cluster.main.kube_configs[0].raw_config
  sensitive = true
}

output "registry_url" {
  value = digitalocean_container_registry.main.endpoint
}