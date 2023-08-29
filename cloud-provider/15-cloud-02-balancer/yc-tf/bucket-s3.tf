

// Создание бакета с использованием ключа

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

resource "yandex_iam_service_account_static_access_key" "keys" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = "Access keys for object storage"
}

resource "yandex_storage_bucket" "backups" {
  bucket        = "nik-2023-s3"
  acl           = "public-read"
  access_key    = yandex_iam_service_account_static_access_key.keys.access_key
  secret_key    = yandex_iam_service_account_static_access_key.keys.secret_key
  force_destroy = "true"
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