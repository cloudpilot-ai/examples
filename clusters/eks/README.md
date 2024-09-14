# Demostration Cluster for CloudPilot AI

See the [AWS documentation](https://docs.aws.amazon.com/eks/latest/userguide/managed-node-groups.html) for additional details on Amazon EKS managed node groups.

The different cluster configuration examples provided are separated per file and independent of the other cluster configurations.

### Prerequisites

- [aws cli](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- [terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)

Run the following command to configure the aws cli with your aws credentials:
```bash
aws configure
```

## Usage

To provision the provided configurations you need to execute:

```bash
$ terraform init
$ terraform apply --auto-approve
```

After finish the process, run the following command to get the `kubeconfig`:
```sh
export KUBECONFIG=~/.kube/demo
aws eks update-kubeconfig --name cluster-demostration
```
Then testing the cluster:
```sh
kubectl get nodes
```

Note that this example may create resources which cost money. Run `terraform destroy --auto-approve` when you don't need these resources.
