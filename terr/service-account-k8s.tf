
resource "yandex_iam_service_account" "regional-account-k8s" {
  name = var.kubernetes_iam_service_account_name
}

resource "yandex_resourcemanager_folder_iam_member" "k8s-clusters-agent" {
  folder_id = var.folder_id
  role      = var.kubernetes_role_k8s_clusters_agent
  member    = "serviceAccount:${yandex_iam_service_account.regional-account-k8s.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "vpc-public-admin" {
  folder_id = var.folder_id
  role      = var.kubernetes_role_vpc_publicAdmin
  member    = "serviceAccount:${yandex_iam_service_account.regional-account-k8s.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "images-puller" {
  folder_id = var.folder_id
  role      = var.kubernetes_role_container_registry_images_puller
  member    = "serviceAccount:${yandex_iam_service_account.regional-account-k8s.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "encrypterDecrypter" {
  folder_id = var.folder_id
  role      = var.kubernetes_role_kms_keys_encrypterDecrypter
  member    = "serviceAccount:${yandex_iam_service_account.regional-account-k8s.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "loggingWriter" {
  folder_id = var.folder_id
  role      = var.kubernetes_role_logging_writer
  member    = "serviceAccount:${yandex_iam_service_account.regional-account-k8s.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "loadBalancerAdmin" {
  folder_id = var.folder_id
  role      = var.kubernetes_role_load_balancer_admin
  member    = "serviceAccount:${yandex_iam_service_account.regional-account-k8s.id}"
}

