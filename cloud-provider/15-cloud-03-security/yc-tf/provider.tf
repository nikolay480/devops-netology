# Configuring the provider

terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.80.0"
    }
  }
}

provider "yandex" {
  folder_id                = var.folder_id
  cloud_id                 = var.cloud_id
  service_account_key_file = file("~/terraform_files/s3-bucket/key.json")
}
