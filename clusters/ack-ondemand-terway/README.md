# Demonstration Cluster for CloudPilot AI

Using this tutorial, you can create a demonstration Aliyun cluster to try CloudPilot AI.

### Prerequisites

- [aliyun cli](https://help.aliyun.com/zh/cli/?spm=a2c4g.11186623.0.0.18ec478dVSmS6M)
  If you use Linux, run the following command to install the aliyun cli:
  ```bash
  wget https://aliyuncli.alicdn.com/aliyun-cli-linux-latest-amd64.tgz
  tar -zxvf aliyun-cli-linux-latest-amd64.tgz
  mv aliyun /usr/local/bin/
  ```

- [terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)

Run the following command to configure the aliyun cli with your aliyun credentials:

```bash
aliyun configure
```

## Usage

Configure the aliyun credentials environment variables:

```
export ALICLOUD_ACCESS_KEY=<aliyun access key>
export ALICLOUD_SECRET_KEY=<aliyun secret key>
export ALICLOUD_REGION="cn-shenzhen"
```

Then, download the repository:

```bash
git clone https://github.com/cloudpilot-ai/examples.git
cd examples/clusters/ack-ondemand-terway
```

Execute the following command to create the ACK cluster:

```bash
export TF_VAR_CLUSTER_NAME=<your_cluster_name>
terraform init
terraform apply --auto-approve
```

After finish the process, run the following command to get the `kubeconfig`:

```bash
export CLUSTER_NAME=<your_cluster_name>
export KUBECONFIG=~/.kube/demo
export CLUSTER_ID=$(aliyun cs GET /clusters | jq -r --arg CLUSTER_NAME "$CLUSTER_NAME" '.[] | select(.name == $CLUSTER_NAME) | .cluster_id')
aliyun cs GET /k8s/$CLUSTER_ID/user_config | jq -r '.config' > $KUBECONFIG
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
