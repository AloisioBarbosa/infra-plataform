# infra-platform

Produto responsável pelos serviços compartilhados instalados sobre o EKS.
Consome o cluster publicado pelo `infra-cluster`; não cria VPC, EKS ou node
groups.

## Estado inicial

O primeiro componente é o Metrics Server, migrado do `infra-cluster` para este
state sem desinstalar o release existente. A configuração usa o chart oficial
`metrics-server/metrics-server` `3.13.1` e a imagem mantida em
`registry.k8s.io`.

## Ordem da migração

1. Aplicar a PR correspondente no `infra-cluster`. O bloco `removed` com
   `destroy = false` deve retirar `helm_release.metrics_server` do state sem
   apagar o release.
2. Confirmar que o plan deste repositório mostra import de
   `kube-system/metrics-server` e atualização do chart, sem criação paralela.
3. Aplicar este repositório.
4. Validar:

   ```bash
   kubectl rollout status deployment/metrics-server -n kube-system
   kubectl top nodes
   kubectl top pods --all-namespaces
   ```

Nunca aplique este repositório antes de concluir o handoff do state no
`infra-cluster`.

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
- instalar Ingress Controller, ExternalDNS, Cert-Manager, Argo CD e Karpenter;
- substituir credenciais estáticas do CI por uma role OIDC exclusiva;
- adicionar políticas, testes e runbooks por componente.
