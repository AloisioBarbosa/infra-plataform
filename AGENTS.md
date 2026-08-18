# AGENTS.md — infra-plataform

## Responsabilidade

Gerencia serviços compartilhados instalados sobre o EKS. Não deve criar ou
alterar recursos pertencentes a `infra-network` ou `infra-cluster`.

## Contrato atual

- cluster: `infra-cluster`;
- região: `us-east-1`;
- ambiente: `dev`;
- backend key legado: `platform/dev/terraform.tfstate`;
- primeiro recurso: `helm_release.metrics_server`;
- chart: repositório oficial do Kubernetes SIGs, versão `3.13.1`;
- o release `kube-system/metrics-server` estava ausente após a recriação do
  cluster e será criado por este state;
- compute crítico: EKS Fargate para Karpenter, CoreDNS e Metrics Server;
- Karpenter: chart `1.14.0`, AMI `al2023@v20260810`;
- NodePool `volatile`: Spot-only, taint `workload-tier=volatile:NoSchedule`;
- instance types: `t3.medium`, `t3.large`, `t3a.medium`, `t3a.large`;
- Managed Node Group preservado como fallback operacional.

## Guardrail de migração

O `infra-cluster` já aplicou seu bloco `removed { destroy = false }`. O plan do
PR #3 confirmou `release not found`, portanto não existe release para importar.
Mantenha o nome `metrics-server`, o namespace `kube-system` e a versão do chart
durante o primeiro apply verde deste state.

## CI

O workflow assume `GitHubActionsOIDCInfraPlataformRole` via GitHub Actions
OIDC nos environments `plan` e `production`. Não reintroduza chaves AWS de
longa duração. O `infra-bootstrap` publica a role e o `infra-cluster` gerencia
seu EKS Access Entry com `AmazonEKSClusterAdminPolicy`.

O `infra-cluster` publica a role IRSA do controller, a fila SQS de
interrupções e o instance profile dos nodes. Não recrie esses recursos neste
repositório.
