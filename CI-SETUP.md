# Configuração do GitHub Actions

## Secrets

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

O principal precisa consultar o EKS e possuir acesso administrativo ao cluster
durante o bootstrap dos componentes de plataforma.

## Variables

| Nome | Valor |
|---|---|
| `AWS_REGION` | `us-east-1` |
| `TF_STATE_BUCKET` | `orange-ks8-logs` |
| `TF_STATE_KEY` | `platform/dev/terraform.tfstate` |
| `TF_VAR_REGION` | `us-east-1` |
| `TF_VAR_CLUSTER_NAME` | `infra-cluster` |
| `TF_VAR_ENVIRONMENT` | `dev` |

Crie os environments `plan` e `production`; proteja `production` com aprovação.
