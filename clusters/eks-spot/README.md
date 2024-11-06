# Demonstration Cluster for CloudPilot AI

See the [AWS documentation](https://docs.aws.amazon.com/eks/latest/userguide/managed-node-groups.html) for additional details on Amazon EKS managed node groups.

## Prerequisites

- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)

Run the following command to configure the aws cli with your aws credentials:

```bash
aws configure
```

## Usage

Download the repository:

```bash
git clone https://github.com/cloudpilot-ai/examples.git
cd examples/clusters/eks-spot
```

Execute the following command to create the EKS cluster:

```bash
terraform init
terraform apply --auto-approve
```

After finish the process, run the following command to get the `kubeconfig`:

```bash
export KUBECONFIG=~/.kube/demo
aws eks update-kubeconfig --name cluster-demonstration
```

Then testing the cluster:

```bash
kubectl get nodes
```

When you finish the testing, please run the following command to destroy the cluster:

Please note, if you have workloads deployed in your cluster,
you need to remove these workloads first. Especially, services associated with load balancers (LB)
may cause dependencies that are cumbersome to resolve manually if not addressed before cluster termination.

```bash
terraform destroy --auto-approve
```

## More

If you want to test GPU nodes rebalance, please do as follows before installing cloudpilot agent:

* Uncommand the code as follows in `main.tf`:

```tf
  # Please run the following command after the cluster ready
  # kubectl create -f https://raw.githubusercontent.com/NVIDIA/k8s-device-plugin/v0.15.0/deployments/static/nvidia-device-plugin.yml
  gpu_node_group = {
      name = "cloudpilot-gpu"
      ami_type = "AL2_x86_64_GPU"

      instance_types = ["g3s.xlarge"]

      min_size     = 0
      max_size     = 4
      desired_size = 1

      capacity_type = "ON_DEMAND"
      spot_max_price = "10"
  }
```

* Init the cluster.
* Install nvidia device plugin:

```sh
kubectl create -f https://raw.githubusercontent.com/NVIDIA/k8s-device-plugin/v0.15.0/deployments/static/nvidia-device-plugin.yml
```

* Create the GPU workload.

```sh
kubectl apply -f manifest/gpu-workload.yaml 
```
