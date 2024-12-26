# Demonstration Cluster for CloudPilot AI

Using this tutorial, you can create a demonstration GKE cluster to try CloudPilot AI.

### Prerequisites

- [gcloud](https://cloud.google.com/sdk/docs/install)
  If you use Linux, run the following command to install the gcloud cli:

  ```bash
  curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-linux-x86_64.tar.gz
  tar -xf google-cloud-cli-linux-x86_64.tar.gz
  ./google-cloud-sdk/install.sh
  ./google-cloud-sdk/bin/gcloud init
  ```

- [terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)

Run the following command to configure the gcloud cli with your gke credentials:

```bash
gcloud auth login
```

## Usage

Then, download the repository:

```bash
git clone https://github.com/cloudpilot-ai/examples.git
cd examples/clusters/gke-ondemand
```

Execute the following command to create the GKE cluster:

```bash
export TF_VAR_PROJECT_ID=<your_project_id>
export TF_VAR_CLUSTER_NAME=cluster-demonstration
terraform init
terraform apply --auto-approve
```

After finish the process, run the following command to get the `kubeconfig`:

```bash
export TF_VAR_PROJECT_ID=<your_project_id>
export TF_VAR_CLUSTER_NAME=cluster-demonstration
export KUBECONFIG=~/.kube/demo
gcloud container clusters get-credentials $TF_VAR_CLUSTER_NAME --region us-central1 --project $TF_VAR_PROJECT_ID
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
export TF_VAR_PROJECT_ID=<your_project_id>
export TF_VAR_CLUSTER_NAME=cluster-demonstration
terraform destroy --auto-approve
```
