resource "helm_release" "karpenter" {
  name             = "karpenter"
  repository       = "oci://public.ecr.aws/karpenter"
  chart            = "karpenter"
  version          = var.karpenter_version
  namespace        = "karpenter"
  create_namespace = true

  atomic          = true
  cleanup_on_fail = true
  wait            = true
  timeout         = 900

  values = [
    yamlencode({
      replicas = 2
      serviceAccount = {
        name = "karpenter"
        annotations = {
          "eks.amazonaws.com/role-arn" = var.karpenter_controller_role_arn
        }
      }
      controller = {
        resources = {
          requests = {
            cpu    = "500m"
            memory = "512Mi"
          }
          limits = {
            cpu    = "500m"
            memory = "512Mi"
          }
        }
      }
      settings = {
        clusterName       = var.cluster_name
        eksControlPlane   = true
        interruptionQueue = var.karpenter_interruption_queue_name
        enableZonalShift  = true
      }
      topologySpreadConstraints = [
        {
          maxSkew           = 1
          topologyKey       = "topology.kubernetes.io/zone"
          whenUnsatisfiable = "ScheduleAnyway"
        }
      ]
    })
  ]
}

resource "helm_release" "karpenter_config" {
  name      = "karpenter-config"
  chart     = "${path.module}/helm/karpenter-config"
  namespace = helm_release.karpenter.namespace

  atomic          = true
  cleanup_on_fail = true
  wait            = true
  timeout         = 600

  values = [
    yamlencode({
      clusterName         = var.cluster_name
      instanceProfile     = var.karpenter_node_instance_profile_name
      amiAlias            = var.karpenter_ami_alias
      subnetIds           = data.aws_eks_cluster.main.vpc_config[0].subnet_ids
      securityGroupId     = data.aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
      spotInstanceTypes   = var.karpenter_spot_instance_types
      nodePoolCpuLimit    = var.karpenter_nodepool_cpu_limit
      nodePoolMemoryLimit = var.karpenter_nodepool_memory_limit
    })
  ]

  depends_on = [
    helm_release.karpenter,
  ]
}
