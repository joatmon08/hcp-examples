output "consul_helm_values" {
  value = templatefile("helm/values.tmpl", {
    consul_host      = var.hcp_consul_host
    cluster_endpoint = module.eks.cluster_endpoint
  })
}