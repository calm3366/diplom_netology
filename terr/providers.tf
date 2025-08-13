terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "> 0.8"
    }
  }
  backend "s3" {
    endpoint                    = "storage.yandexcloud.net"
    bucket                      = "k8s-bucket-netology"
    region                      = "ru-central1"
    key                         = "terraform/terraform.tfstate"
    skip_region_validation      = true
    skip_credentials_validation = true
  }
  required_version = ">=0.13"
}

provider "yandex" {
  token     = var.token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
}