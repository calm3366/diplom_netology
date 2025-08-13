###cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "vpc_subnet" {
  type = list(object({ vpc_name = string, zone = string, v4_cidr_blocks = list(string) }))
  default = [{
    vpc_name       = "public"
    zone           = "ru-central1-a"
    v4_cidr_blocks = ["192.168.10.0/24"]
    },
    {
      vpc_name       = "public2"
      zone           = "ru-central1-b"
      v4_cidr_blocks = ["192.168.20.0/24"]
    },
    {
      vpc_name       = "public3"
      zone           = "ru-central1-d"
      v4_cidr_blocks = ["192.168.30.0/24"]
  }]
  description = "VPC subnet config"
}

variable "vpc_name" {
  type        = string
  default     = "my_network"
  description = "VPC network name"
}

variable "ssh_login_nodes" {
  type        = string
  default     = "admin"
  description = "ssh login for k8s nodes and test VM"
}

variable "ssh_file" {
  type        = string
  default     = "~/.ssh/id_rsa.pub"
  description = "public key for all VMs"
}

variable "vm_family" {
  type    = string
  default = "ubuntu-2004-lts"
}

variable "file_cloud-init" {
  type        = string
  default     = "./cloud-init-vm.yaml"
  description = "cloud-init file for nat-instance and test VMs and k8s node groups"
}

variable "kubernetes_cluster_name" {
  type        = string
  default     = "k8s-regional"
  description = "kubernetes cluster name"
}

variable "kubernetes_cluster_public_ip" {
  type        = string
  default     = "true"
  description = "kubernetes_cluster_public_ip ?"
}

variable "kubernetes_iam_service_account_name" {
  type        = string
  default     = "regional-k8s-account"
  description = "K8S regional service account"
}

variable "kubernetes_role_k8s_clusters_agent" {
  type        = string
  default     = "k8s.clusters.agent"
  description = "Сервисному аккаунту назначается роль k8s.clusters.agent"
}
variable "kubernetes_role_vpc_publicAdmin" {
  type        = string
  default     = "vpc.publicAdmin"
  description = "Сервисному аккаунту назначается роль vpc.publicAdmin"
}
variable "kubernetes_role_container_registry_images_puller" {
  type        = string
  default     = "container-registry.images.puller"
  description = "Сервисному аккаунту назначается роль container-registry.images.puller"
}
variable "kubernetes_role_kms_keys_encrypterDecrypter" {
  type        = string
  default     = "kms.keys.encrypterDecrypter"
  description = "Сервисному аккаунту назначается роль kms.keys.encrypterDecrypter"
}

variable "kubernetes_role_logging_writer" {
  type        = string
  default     = "logging.writer"
  description = "Сервисному аккаунту назначается роль logging.writer"
}

variable "kubernetes_role_load_balancer_admin" {
  type        = string
  default     = "load-balancer.admin"
  description = "Сервисному аккаунту назначается роль load-balancer.admin"
}

variable "kubernetes_nodes" {
  type = list(object({ group_name = string, platform_id = string }))
  default = [{
    group_name  = "k8s-nodes-a"
    platform_id = "standard-v1"
    },
    {
      group_name  = "k8s-nodes-b"
      platform_id = "standard-v1"
    },
    {
      group_name  = "k8s-nodes-d"
      platform_id = "standard-v2"
  }]
  description = "K8s nodes config"
}

variable "kubernetes_instances_network_interface_nat" {
  type        = string
  default     = "true"
  description = "kubernetes_instances_network_interface_nat"
}

variable "kubernetes_instances_network_acceleration_type" {
  type        = string
  default     = "standard"
  description = "kubernetes_instances_network_acceleration_type"
}

variable "kubernetes_instances_preemptible" {
  type        = string
  default     = "false"
  description = "kubernetes_instances_preemptible"
}

variable "kubernetes_instances_resources_memory" {
  type        = string
  default     = "8"
  description = "kubernetes_instances_resources_memory"
}

variable "kubernetes_instances_resources_core_fraction" {
  type        = string
  default     = "5"
  description = "kubernetes_instances_resources_memory"
}

variable "kubernetes_instances_resources_cores" {
  type        = string
  default     = "4"
  description = "kubernetes_instances_resources_cores"
}

variable "kubernetes_instances_container_runtime_type" {
  type        = string
  default     = "containerd"
  description = "kubernetes_instances_container_runtime_type"
}

variable "kubernetes_instances_scale_policy_fixed" {
  type        = string
  default     = "1"
  description = "фиксированное значение узлов в группе нод"
}

variable "kubernetes_instances_boot_disk_type" {
  type        = string
  default     = "network-hdd"
  description = "kubernetes_instances_boot_disk_type"
}

variable "kubernetes_instances_boot_disk_size" {
  type        = string
  default     = "64"
  description = "kubernetes_instances_boot_disk_size"
}

variable "kubernetes_instances_serial_port" {
  type        = bool
  default     = false
  description = "Enable/disable serial port on nodes"
}

variable "kubernetes_instances_name" {
  type        = string
  default     = "netology-k8s-node-{instance.short_id}-{instance_group.id}"
  description = "kubernetes_instances_name https://yandex.cloud/ru/docs/managed-kubernetes/operations/node-group/node-group-create#tf_1"
}

variable "bucket_name" {
  type        = string
  default     = "k8s-bucket-netology"
  description = "bucket_name for k8s state file"
}

variable "description_for_service_account_static_access_key" {
  type        = string
  default     = "static access key for object storage"
  description = "description_for_service_account_static_access_key"
}

variable "sa_role_for_bucket_edit" {
  type        = string
  default     = "storage.editor"
  description = "Сервисному аккаунту назначается роль storage.editor"
}

variable "my-docker-registry" {
  type        = string
  default     = "my-docker-registry"
  description = "Реджистри для собственных докер образов"
}
