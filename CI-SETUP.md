# Configuração do GitHub Actions

## Autenticação AWS

O workflow assume via GitHub Actions OIDC a role
`GitHubActionsOIDCInfraPlataformRole`, publicada pelo `infra-bootstrap`. Não
configure chaves AWS de longa duração. A trust policy autoriza somente os
environments `plan` e `production`.

Antes do primeiro deploy, o `infra-cluster` deve aplicar o EKS Access Entry
dessa role associado a `AmazonEKSClusterAdminPolicy`.

## Variables

| Nome | Valor |
|---|---|
| `AWS_REGION` | `us-east-1` |
| `AWS_ROLE_ARN` | ARN de `GitHubActionsOIDCInfraPlataformRole` |
| `TF_STATE_BUCKET` | `orange-ks8-logs` |
| `TF_STATE_KEY` | `platform/dev/terraform.tfstate` |
| `TF_VAR_REGION` | `us-east-1` |
| `TF_VAR_CLUSTER_NAME` | `infra-cluster` |
| `TF_VAR_ENVIRONMENT` | `dev` |
| `KARPENTER_CONTROLLER_ROLE_ARN` | output `karpenter_controller_role_arn` do `infra-cluster` |
| `KARPENTER_INTERRUPTION_QUEUE_NAME` | output `karpenter_interruption_queue_name` do `infra-cluster` |
| `KARPENTER_NODE_INSTANCE_PROFILE_NAME` | output `karpenter_node_instance_profile_name` do `infra-cluster` |

Crie os environments `plan` e `production`; proteja `production` com aprovação.
