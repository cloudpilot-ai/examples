variable "availability_zone" {  # 指定虚拟交换机（vSwitches）的可用区。
  description = "The availability zones of vswitches."
  # 请跟下文main.tf配置文件中的地域保持一致。
  default     = ["cn-shenzhen-c", "cn-shenzhen-e", "cn-shenzhen-f"]
}

variable "node_vswitch_ids" { # 指定交换机ID（vSwitch IDs）的列表。
  description = "List of existing node vswitch ids for terway."
  type        = list(string)
  default     = []
}

variable "node_vswitch_cidrs" { # 当没有提供node_vswitch_ids时，这个变量定义了用于创建新vSwitches的CIDR地址块列表。
  description = "List of cidr blocks used to create several new vswitches when 'node_vswitch_ids' is not specified."
  type        = list(string)
  default     = ["172.16.0.0/23", "172.16.2.0/23", "172.16.4.0/23"]
}

variable "terway_vswitch_ids" { # 指定网络组件Terway配置。如果为空，默认会根据terway_vswitch_cidrs的创建新的terway vSwitch。
  description = "List of existing pod vswitch ids for terway."
  type        = list(string)
  default     = []
}

variable "terway_vswitch_cidrs" {  # 当没有指定terway_vswitch_ids时，用于创建Terway使用的vSwitch的CIDR地址块。
  description = "List of cidr blocks used to create several new vswitches when 'terway_vswitch_ids' is not specified."
  type        = list(string)
  default     = ["172.16.208.0/20", "172.16.224.0/20", "172.16.240.0/20"]
}

# Node Pool worker_instance_types
variable "worker_instance_types" { # 定义了用于启动工作节点的ECS实例类型。
  description = "The ecs instance types used to launch worker nodes."
  default     = ["ecs.u1-c1m2.xlarge"]
}

# Password for Worker nodes
variable "password" {
  description = "The password of ECS instance."
  default     = "Test123456"
}

# Cluster Addons
variable "cluster_addons" {    # 指定ACK集群安装的组件。声明每个组件的名称和对应配置。
  type = list(object({
    name   = string
    config = string
  }))

  default = [
    {
      "name"   = "terway-eniip",
      "config" = "",
    },
    {
      "name"   = "nginx-ingress-controller",
      "config" = "{\"IngressSlbNetworkType\":\"internet\"}",
    },
    {
      "name"   = "ack-node-problem-detector",
      "config" = "{\"sls_project_name\":\"\"}",
    },
    {
      "name"   = "csi-plugin",
      "config" = "",
    },
    {
      "name"   = "csi-provisioner",
      "config" = "",
    }
  ]
}
