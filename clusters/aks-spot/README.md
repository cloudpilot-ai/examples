# Demonstration AKS Spot Cluster for CloudPilot AI

This example creates an AKS cluster with a small on-demand system node pool and a spot user node pool. AKS requires the system node pool to use regular capacity, so the spot capacity is modeled as a separate user pool.

Node pools use fixed `node_count` values and do not enable AKS cluster autoscaler by default.

## Zonal Behavior

- `TF_VAR_zones` applies to both node pools by default.
- If your subscription allows zonal AKS for both pools, you can keep using only `TF_VAR_zones`.
- If Azure rejects the system pool with `AvailabilityZoneNotSupported`, use:
  - `TF_VAR_system_zones='[]'`
  - `TF_VAR_spot_zones='["<zone>"]'` or `["1","2","3"]`
- The Terraform in this directory now supports those per-pool overrides through:
  - `TF_VAR_system_zones`
  - `TF_VAR_spot_zones`
- Zone availability and quota can differ by region, subscription, and VM size, so treat the defaults here as an example starting point rather than a universal guarantee.

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
cd src/cluster-setup/clusters/aks-spot
export TF_VAR_CLUSTER_NAME=<unique-cluster-name>
export TF_VAR_location=centralus
# Optional: enable zones when your region/subscription/VM size combination supports them.
# export TF_VAR_zones='["1","2","3"]'
# Optional: override zones per pool. Useful when system pool must stay regional
# but the spot user pool should be zonal.
# export TF_VAR_system_zones='[]'
# export TF_VAR_spot_zones='["1"]'
# Optional: override VM sizes if your subscription allows different SKUs.
# export TF_VAR_system_node_vm_size=<supported-vm-size>
# export TF_VAR_spot_node_vm_size=<supported-vm-size>

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

kubectl get nodes -L kubernetes.azure.com/scalesetpriority,cloudpilot.ai/capacity-type
kubectl top nodes
```

For a direct zonal verification, also check the zone label and the node pool zones:

```bash
kubectl get nodes -L topology.kubernetes.io/zone,kubernetes.azure.com/agentpool

az aks show \
  --resource-group ${TF_VAR_CLUSTER_NAME}-rg \
  --name ${TF_VAR_CLUSTER_NAME} \
  --query '{systemZones:agentPoolProfiles[?name==`system`].availabilityZones|[0],spotZones:agentPoolProfiles[?name==`spot`].availabilityZones|[0]}' \
  -o json
```

The spot pool is tainted with `kubernetes.azure.com/scalesetpriority=spot:NoSchedule`. Workloads that should run on spot nodes need a matching toleration.

If `kubectl top nodes` is not available, install Metrics Server:

```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
kubectl rollout status deployment/metrics-server -n kube-system --timeout=120s
```

## Cleanup

Remove workloads and load balancer services first, then destroy the cluster:

```bash
cd src/cluster-setup/clusters/aks-spot
export TF_VAR_CLUSTER_NAME=<unique-cluster-name>
export TF_VAR_location=<region>
terraform destroy --auto-approve
```
