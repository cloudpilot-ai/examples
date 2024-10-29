# Demostration Cluster for CloudPilot AI


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

Configure the aliyun cridentials environment variables:
```
export ALICLOUD_ACCESS_KEY=<aliyun access key>
export ALICLOUD_SECRET_KEY=<aliyun secret key>
export ALICLOUD_REGION="cn-shenzhen"   
```

The, download the repository:
```bash
git clone https://github.com/cloudpilot-ai/examples.git
cd examples/clusters/ack
```
Execute the following command to create the ACK cluster:
```bash
terraform init
terraform apply --auto-approve
```

After finish the process, run the following command to get the `kubeconfig`:
```bash
export KUBECONFIG=~/.kube/demo
export CLUSTER_ID=$(aliyun cs GET /clusters | jq -r '.[] | select(.name == "cluster-demonstration") | .cluster_id')
aliyun cs GET /k8s/$CLUSTER_ID/user_config | jq -r '.config' > $KUBECONFIG
```

Then testing the cluster:
```bash
kubectl get nodes
```

Note that this example may create resources which cost money. Run `terraform destroy --auto-approve` when you don't need these resources.

