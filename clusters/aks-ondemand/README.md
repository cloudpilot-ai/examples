# Demonstration AKS On-Demand Cluster for CloudPilot AI

This example creates an AKS cluster with an on-demand system node pool, Azure CNI, workload identity, and OIDC issuer enabled.

The node pool uses a fixed `node_count` and does not enable AKS cluster autoscaler by default.

## Zonal Notes

- `TF_VAR_zones` applies directly to the AKS `system` pool in this example.
- If Azure rejects a zonal system pool with `AvailabilityZoneNotSupported`, this on-demand example has no separate user pool to fall back to.
- In that case, either:
  - pick another region / VM size combination that is zonal in your subscription, or
  - use the spot example in [../aks-spot/README.md](../aks-spot/README.md), which now supports separate `system` and `spot` zone overrides.

## Prerequisites

- [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli)
- [Terraform](https://developer.hashicorp.com/terraform/install)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)

Authenticate and select the subscription:

```bash
az login
az account set --subscription <subscription-id>
```

## Usage

Use a unique cluster name. The default `cluster-demonstration` is a placeholder.

```bash
cd src/cluster-setup/clusters/aks-ondemand
export TF_VAR_CLUSTER_NAME=<unique-cluster-name>
export TF_VAR_location=eastus
# Optional: only set zones when AKS supports zones for your region/subscription.
# export TF_VAR_zones='["1","2","3"]'
# Optional: override VM size if your subscription allows a different SKU.
# export TF_VAR_system_node_vm_size=<supported-vm-size>

terraform init
terraform plan
terraform apply --auto-approve
```

Configure kubectl with a dedicated kubeconfig:

```bash
export KUBECONFIG=~/.kube/aks-${TF_VAR_CLUSTER_NAME}.yaml
az aks get-credentials \
  --resource-group ${TF_VAR_CLUSTER_NAME}-rg \
  --name ${TF_VAR_CLUSTER_NAME} \
  --file $KUBECONFIG \
  --overwrite-existing

kubectl get nodes
kubectl top nodes
```

If `kubectl top nodes` is not available, install Metrics Server:

```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
kubectl rollout status deployment/metrics-server -n kube-system --timeout=120s
```

## Cleanup

Remove workloads and load balancer services first, then destroy the cluster:

```bash
cd src/cluster-setup/clusters/aks-ondemand
export TF_VAR_CLUSTER_NAME=<unique-cluster-name>
terraform destroy --auto-approve
```
