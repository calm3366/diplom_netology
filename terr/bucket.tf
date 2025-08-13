resource "yandex_resourcemanager_folder_iam_member" "s3-editor-role" {
  folder_id = var.folder_id
  role      = var.sa_role_for_bucket_edit
  member    = "serviceAccount:${yandex_iam_service_account.regional-account-k8s.id}"
}

resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.regional-account-k8s.id
  description        = var.description_for_service_account_static_access_key
}

resource "yandex_storage_bucket" "k8s-bucket" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = var.bucket_name
}
