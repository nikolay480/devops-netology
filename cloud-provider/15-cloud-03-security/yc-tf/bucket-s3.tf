
// Создание бакета с использованием ключа

# Create service account

resource "yandex_iam_service_account" "sa" {
  folder_id   = var.folder_id
  description = "Service account for terraform"
  name        = "sa"
}

resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
  folder_id = var.folder_id
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "sa-kms-encrypt" {
  folder_id = var.folder_id
  role      = "kms.keys.encrypterDecrypter"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}


resource "yandex_iam_service_account_static_access_key" "keys" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = "Access keys for object storage"
}

# Create kms symmetric key

resource "yandex_kms_symmetric_key" "kms-a" {
  name              = "kms-a"
  description       = "kms symmetric key"
  default_algorithm = "AES_256"
  rotation_period   = "120h"
  lifecycle {
    prevent_destroy = false
  }
}
# Create bucket

resource "yandex_storage_bucket" "backups" {
  bucket        = "nik-2023-s3"
  acl           = "public-read"
  access_key    = yandex_iam_service_account_static_access_key.keys.access_key
  secret_key    = yandex_iam_service_account_static_access_key.keys.secret_key
  force_destroy = "true"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.kms-a.id
        sse_algorithm     = "aws:kms"
      }
    }
  }
  website {
    index_document = "index.html"
  }
}

resource "yandex_storage_object" "image" {
  access_key = yandex_iam_service_account_static_access_key.keys.access_key
  secret_key = yandex_iam_service_account_static_access_key.keys.secret_key
  acl        = "public-read"
  bucket     = "nik-2023-s3"
  key        = "hawk.jpg"
  source     = "./files/hawk.jpg"
  depends_on = [
    yandex_storage_bucket.backups,
  ]
}