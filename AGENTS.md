# AGENTS.md — infra-platform

## Responsabilidade

Gerencia serviços compartilhados instalados sobre o EKS. Não deve criar ou
alterar recursos pertencentes a `infra-network` ou `infra-cluster`.

## Contrato atual

- cluster: `infra-cluster`;
- região: `us-east-1`;
- ambiente: `dev`;
- backend key: `platform/dev/terraform.tfstate`;
- primeiro recurso: `helm_release.metrics_server`;
- chart: repositório oficial do Kubernetes SIGs, versão `3.13.1`;
- import ID: `kube-system/metrics-server`.

## Guardrail de migração

O apply só pode ocorrer depois que o `infra-cluster` aplicar seu bloco
`removed { destroy = false }`. O import declarativo assume o release existente;
não remova o import nem altere o nome/namespace antes do primeiro apply verde.

## CI

O workflow usa temporariamente `AWS_ACCESS_KEY_ID` e
`AWS_SECRET_ACCESS_KEY`. OIDC permanece como melhoria prioritária.
