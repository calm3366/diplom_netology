resource "yandex_kubernetes_cluster" "k8s-cluster" {
  name       = var.kubernetes_cluster_name
  network_id = yandex_vpc_network.network.id
    master {
      dynamic "master_location" {
        for_each =  var.vpc_subnet
        content {
          zone      = master_location.value["zone"]
        }
    }
    security_group_ids = [yandex_vpc_security_group.regional-k8s-sg.id, yandex_vpc_security_group.regional-k8s-sg-api.id]
    public_ip          = var.kubernetes_cluster_public_ip
  }
  service_account_id      = yandex_iam_service_account.regional-account-k8s.id
  node_service_account_id = yandex_iam_service_account.regional-account-k8s.id
  depends_on = [
    yandex_resourcemanager_folder_iam_member.k8s-clusters-agent,
    yandex_resourcemanager_folder_iam_member.vpc-public-admin,
    yandex_resourcemanager_folder_iam_member.images-puller,
    yandex_resourcemanager_folder_iam_member.encrypterDecrypter
  ]
}

resource "yandex_kubernetes_node_group" "k8s_nodes" {
  for_each       = { for k in var.kubernetes_nodes : index(var.kubernetes_nodes, k) => k }
  cluster_id = yandex_kubernetes_cluster.k8s-cluster.id
  name       = each.value.group_name
  instance_template {
    name        = var.kubernetes_instances_name
    platform_id = each.value.platform_id
    network_interface {
      nat        = var.kubernetes_instances_network_interface_nat
      subnet_ids = [yandex_vpc_subnet.public_subnet[each.key].id]
      security_group_ids = [
        yandex_vpc_security_group.regional-k8s-sg.id,
        yandex_vpc_security_group.regional-k8s-sg-ssh.id,
        yandex_vpc_security_group.regional-k8s-sg-nodeport.id
      ]
    }
    network_acceleration_type = var.kubernetes_instances_network_acceleration_type
    scheduling_policy {
      preemptible = var.kubernetes_instances_preemptible
    }
    resources {
      memory        = var.kubernetes_instances_resources_memory
      cores         = var.kubernetes_instances_resources_cores
      core_fraction = var.kubernetes_instances_resources_core_fraction
    }
    boot_disk {
      type = var.kubernetes_instances_boot_disk_type
      size = var.kubernetes_instances_boot_disk_size
    }
    container_runtime {
      type = var.kubernetes_instances_container_runtime_type
    }
    metadata = {
      serial-port-enable = var.kubernetes_instances_serial_port
      user-data          = data.template_file.cloudinit.rendered
    }
  }
  allocation_policy {
    location {
      zone = yandex_vpc_subnet.public_subnet[each.key].zone
    }
  }
  scale_policy {
    fixed_scale {
      size = var.kubernetes_instances_scale_policy_fixed
    }
  }
}


data "template_file" "cloudinit" {
  template = file(var.file_cloud-init)
  vars = {
    username       = var.ssh_login_nodes
    ssh_public_key = local.file_ssh
  }
}

resource "local_file" "k8s-master-external-ip" {
  content = "https://${yandex_kubernetes_cluster.k8s-cluster.master[0].external_v4_address}"
  filename = "../docker/k8s-master-external-ip.txt"
}
