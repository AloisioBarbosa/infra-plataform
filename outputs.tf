output "metrics_server_status" {
  description = "Status do release Helm do Metrics Server."
  value       = helm_release.metrics_server.status
}

output "metrics_server_version" {
  description = "Versao do chart oficial instalada."
  value       = helm_release.metrics_server.version
}
