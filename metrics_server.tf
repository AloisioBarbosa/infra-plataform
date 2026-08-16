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

  values = [
    yamlencode({
      containerPort = 10251
      replicas      = 2
      podDisruptionBudget = {
        enabled        = true
        maxUnavailable = 1
      }
      resources = {
        requests = {
          cpu    = "100m"
          memory = "200Mi"
        }
        limits = {
          cpu    = "100m"
          memory = "200Mi"
        }
      }
      topologySpreadConstraints = [
        {
          maxSkew           = 1
          topologyKey       = "topology.kubernetes.io/zone"
          whenUnsatisfiable = "ScheduleAnyway"
          labelSelector = {
            matchLabels = {
              "app.kubernetes.io/name" = "metrics-server"
            }
          }
        }
      ]
    })
  ]
}

# Assume o release preservado pelo bloco removed do infra-cluster.
import {
  to = helm_release.metrics_server
  id = "kube-system/metrics-server"
}
