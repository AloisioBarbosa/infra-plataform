resource "helm_release" "metrics_server" {
  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  version    = "3.13.1"
  namespace  = "kube-system"

  atomic          = true
  cleanup_on_fail = true
  wait            = true
  timeout         = 600
}

# Assume o release preservado pelo bloco removed do infra-cluster.
import {
  to = helm_release.metrics_server
  id = "kube-system/metrics-server"
}
