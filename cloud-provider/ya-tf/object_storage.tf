# Storage backet

resource "yandex_storage_bucket" "nik-devops" {
  bucket        = "backup-backet"
  force_destroy = true
  access_key    = yandex_iam_service_account_static_access_key.static-access-key.access_key
  secret_key    = yandex_iam_service_account_static_access_key.static-access-key.secret_key
}


# Service accounts

resource "yandex_iam_service_account_static_access_key" "static-access-key" {
  service_account_id = var.sa_id
}
