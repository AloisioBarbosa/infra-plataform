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
