# Create kms symmetric key

resource "yandex_kms_symmetric_key" "kms-key" {
  name              = "kms-1"
  description       = "kms symmetric key"
  default_algorithm = "AES_128"
  rotation_period   = "8760h"
  lifecycle {
    prevent_destroy = false
  }
}

resource "yandex_kms_symmetric_key_iam_binding" "viewer" {
  symmetric_key_id = yandex_kms_symmetric_key.kms-key.id
  role             = "viewer"
  members = [
    "serviceAccount:${yandex_iam_service_account.sa-k8s.id}",
  ]
}