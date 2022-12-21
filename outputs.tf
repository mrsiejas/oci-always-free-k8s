output "cluster_public_ip" {
  value = module.network.reserved_public_ip.ip_address
}

output "cluster_public_address" {
  value = var.cluster_public_dns_name
}

output "admin_token" {
  value = module.k8s_scaffold.admin_token
}
