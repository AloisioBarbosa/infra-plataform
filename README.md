# infra-plataform

Produto responsável pelos serviços compartilhados instalados sobre o EKS.
Consome o cluster publicado pelo `infra-cluster`; não cria VPC, EKS ou node
groups.

O produto e o repositório usam o nome canônico `infra-plataform`. A chave do
state permanece `platform/dev/terraform.tfstate` como identificador legado;
alterá-la exige uma migração explícita do backend.

## Estado inicial

O primeiro componente é o Metrics Server. O handoff não destrutivo foi aplicado
no `infra-cluster`, mas o plan posterior confirmou que o release não existia no
cluster recriado; por isso este state o cria sem import declarativo. A
configuração usa o chart oficial `metrics-server/metrics-server` `3.13.1` e a
imagem mantida em `registry.k8s.io`.

## Compute híbrido

Os controllers críticos compatíveis executam em EKS Fargate. O Metrics Server
usa porta `10251`, duas réplicas e PodDisruptionBudget. O controller do
Karpenter executa no namespace `karpenter` com IRSA.

O NodePool `volatile` provisiona somente Spot nos tipos `t3.medium`,
`t3.large`, `t3a.medium` e `t3a.large`. Ele possui o taint
`workload-tier=volatile:NoSchedule`; apenas aplicações com toleration
explícita podem consumir essa capacidade.

O Managed Node Group permanece disponível como fallback. A chave de state
legada continua `platform/dev/terraform.tfstate`.

## Ordem da migração

1. Aplicar a PR correspondente no `infra-cluster`. O bloco `removed` com
   `destroy = false` deve retirar `helm_release.metrics_server` do state sem
   apagar o release.
2. Confirmar que o plan deste repositório cria somente
   `kube-system/metrics-server` e os componentes planejados da plataforma, sem
   destruir recursos existentes.
3. Aplicar este repositório.
4. Validar:

   ```bash
   kubectl rollout status deployment/metrics-server -n kube-system
   kubectl top nodes
   kubectl top pods --all-namespaces
   ```

Nunca aplique este repositório antes de concluir o handoff do state no
`infra-cluster`.

O pipeline assume `GitHubActionsOIDCInfraPlataformRole` via OIDC. O
`infra-bootstrap` publica a role e o `infra-cluster` publica sua autorização
Kubernetes por EKS Access Entry; ambos precisam estar aplicados antes do plan.

## Uso local

```bash
cp terraform.tfvars.example terraform.tfvars
terraform init \
  -backend-config="bucket=<bucket>" \
  -backend-config="key=platform/dev/terraform.tfstate" \
  -backend-config="region=us-east-1" \
  -backend-config="use_lockfile=true"
terraform plan
```

## Roadmap

- migrar `kube-state-metrics` pelo mesmo padrão não destrutivo;
- instalar Ingress Controller, ExternalDNS, Cert-Manager e Argo CD;
- adicionar políticas, testes e runbooks por componente.
