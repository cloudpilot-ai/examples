provider "alicloud" {
  region = "cn-shenzhen"
  #请与variable.tf 配置文件中得地域保持一致。
}

resource "random_uuid" "this" {}
# 默认资源名称。
locals {
  k8s_name                 = var.CLUSTER_NAME
  k8s_name_flannel         = "${var.CLUSTER_NAME}-flannel"
  new_vpc_name             = "vpc-${var.CLUSTER_NAME}"
  nodepool_name            = "default-nodepool"
  log_project_name         = "log-for-${var.CLUSTER_NAME}"
}

# 节点ECS实例配置。将查询满足CPU、Memory要求的ECS实例类型。
data "alicloud_instance_types" "default" {
  cpu_core_count       = 8
  memory_size          = 32
  availability_zone    = var.availability_zone[0]
  kubernetes_node_role = "Worker"
}

# 满足实例规格的AZ。
data "alicloud_zones" "default" {
  available_instance_type = data.alicloud_instance_types.default.instance_types[0].id
}

# 专有网络。
resource "alicloud_vpc" "default" {
  vpc_name   = local.new_vpc_name
  cidr_block = "172.16.0.0/12"
}

# Node交换机。
resource "alicloud_vswitch" "vswitches" {
  count      = length(var.node_vswitch_ids) > 0 ? 0 : length(var.node_vswitch_cidrs)
  vpc_id     = alicloud_vpc.default.id
  cidr_block = element(var.node_vswitch_cidrs, count.index)
  zone_id    = element(var.availability_zone, count.index)
}

# Pod交换机。
resource "alicloud_vswitch" "terway_vswitches" {
  count      = length(var.terway_vswitch_ids) > 0 ? 0 : length(var.terway_vswitch_cidrs)
  vpc_id     = alicloud_vpc.default.id
  cidr_block = element(var.terway_vswitch_cidrs, count.index)
  zone_id    = element(var.availability_zone, count.index)
}

# Kubernetes托管版。
resource "alicloud_cs_managed_kubernetes" "default" {
  name               = local.k8s_name            # Kubernetes集群名称。
  cluster_spec       = "ack.standard"           # 创建Std版集群。
  version            = "1.33.3-aliyun.1"
  vswitch_ids = split(",", join(",", alicloud_vswitch.vswitches.*.id)) # 节点池所在的vSwitch。指定一个或多个vSwitch的ID，必须在availability_zone指定的区域中。
  pod_vswitch_ids    = split(",", join(",", alicloud_vswitch.terway_vswitches.*.id)) # Pod虚拟交换机。
  new_nat_gateway    = true               # 是否在创建Kubernetes集群时创建新的NAT网关。默认为true。
  service_cidr       = "10.11.0.0/16"     # Pod网络的CIDR块。当cluster_network_type设置为flannel，你必须设定该参数。它不能与VPC CIDR相同，并且不能与VPC中的Kubernetes集群使用的CIDR相同，也不能在创建后进行修改。集群中允许的最大主机数量：256。
  slb_internet_enabled = true             # 是否为API Server创建Internet负载均衡。默认为false。
  enable_rrsa        = true

  dynamic "addons" {    # 组件管理。
    for_each = var.cluster_addons
    content {
      name   = lookup(addons.value, "name", var.cluster_addons)
      config = lookup(addons.value, "config", var.cluster_addons)
    }
  }
}

#Create a node pool with spot instance.
resource "alicloud_cs_kubernetes_node_pool" "spot_instance" {
  cluster_id = alicloud_cs_managed_kubernetes.default.id     # Kubernetes集群名称。
  node_pool_name = local.nodepool_name
  vswitch_ids = split(",", join(",", alicloud_vswitch.vswitches.*.id))  # 节点池所在的vSwitch。指定一个或多个vSwitch的ID，必须在availability_zone指定的区域中。
  instance_types       = var.worker_instance_types
  image_id = "lifsea_3_x64_10G_containerd_1_6_28_alibase_20240705.vhd"
  runtime_name    = "containerd"
  runtime_version = "1.6.20"
  desired_size = 2
  password = var.password                # SSH登录集群节点的密码。
  install_cloud_monitor = true           # 是否为Kubernetes的节点安装云监控。
  system_disk_category = "cloud_auto"
  system_disk_size     = 20
  image_type = "ContainerOS"

  # spot config
  spot_strategy = "SpotWithPriceLimit"
  spot_price_limit {
    instance_type = var.worker_instance_types.0
    # Different instance types have different price caps
    price_limit = "1.00"
  }
}
