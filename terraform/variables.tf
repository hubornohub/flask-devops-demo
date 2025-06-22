variable "do_token" {
  description = "DigitalOcean API token"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "Region to deploy resources"
  type        = string
  default     = "blr1"
}

variable "cluster_name" {
  description = "Kubernetes cluster name"
  type        = string
}

variable "registry_name" {
  description = "Container registry name"
  type        = string
}