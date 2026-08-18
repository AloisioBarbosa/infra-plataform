variable "region" {
  type        = string
  description = "Regiao AWS do cluster EKS."
}

variable "cluster_name" {
  type        = string
  description = "Nome do cluster EKS consumido por este produto."
}

variable "environment" {
  type        = string
  description = "Ambiente da plataforma."

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment deve ser dev, staging ou prod."
  }
}

variable "karpenter_version" {
  type        = string
  description = "Versao fixa do chart oficial do Karpenter."
  default     = "1.14.0"
}

variable "karpenter_controller_role_arn" {
  type        = string
  description = "ARN IRSA do controller publicado pelo infra-cluster."
}

variable "karpenter_interruption_queue_name" {
  type        = string
  description = "Nome da fila SQS de interrupcoes publicada pelo infra-cluster."
}

variable "karpenter_node_instance_profile_name" {
  type        = string
  description = "Instance profile dos nodes publicado pelo infra-cluster."
}

variable "karpenter_ami_alias" {
  type        = string
  description = "Alias fixo da AMI AL2023 validada para o cluster."
  default     = "al2023@v20260810"
}

variable "karpenter_spot_instance_types" {
  type        = list(string)
  description = "Tipos EC2 permitidos no NodePool Spot de workloads volateis."
  default = [
    "t3.medium",
    "t3.large",
    "t3a.medium",
    "t3a.large",
  ]

  validation {
    condition     = length(var.karpenter_spot_instance_types) >= 2
    error_message = "Informe pelo menos dois instance types para diversificar capacidade Spot."
  }
}

variable "karpenter_nodepool_cpu_limit" {
  type        = string
  description = "Limite agregado de CPU do NodePool Spot."
  default     = "20"
}

variable "karpenter_nodepool_memory_limit" {
  type        = string
  description = "Limite agregado de memoria do NodePool Spot."
  default     = "80Gi"
}
