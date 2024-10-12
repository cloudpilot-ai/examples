# Demostration Cluster for CloudPilot AI

See the [AWS documentation](https://docs.aws.amazon.com/eks/latest/userguide/managed-node-groups.html) for additional details on Amazon EKS managed node groups.

### Prerequisites

- [aws cli](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- [terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)

Run the following command to configure the aws cli with your aws credentials:
```bash
aws configure
```

## Usage

Download the repository:
```bash
git clone https://github.com/cloudpilot-ai/examples.git
cd examples/clusters/eks
```
Execute the following command to create the EKS cluster:
```bash
terraform init
terraform apply --auto-approve
```

After finish the process, run the following command to get the `kubeconfig`:
```bash
export KUBECONFIG=~/.kube/demo
aws eks update-kubeconfig --name cluster-demostration
```
Then testing the cluster:
```bash
kubectl get nodes
```

Note that this example may create resources which cost money. Run `terraform destroy --auto-approve` when you don't need these resources.
