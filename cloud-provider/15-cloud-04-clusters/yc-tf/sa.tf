
# Create service account for k8s

resource "yandex_iam_service_account" "sa-k8s" {
 name        = "sa-k8s"
 description = "Service account for k8s"
}

resource "yandex_resourcemanager_folder_iam_member" "editor" {
 # Сервисному аккаунту "sa-k8s" назначается роль "editor".
 folder_id = var.folder_id
 role      = "editor"
 member    = "serviceAccount:${yandex_iam_service_account.sa-k8s.id}"
 depends_on = [yandex_iam_service_account.sa-k8s]
}

resource "yandex_resourcemanager_folder_iam_member" "images-puller" {
 # Сервисному аккаунту "sa-k8s" назначается роль "container-registry.images.puller".
 folder_id = var.folder_id
 role      = "container-registry.images.puller"
 member    = "serviceAccount:${yandex_iam_service_account.sa-k8s.id}"
 depends_on = [yandex_iam_service_account.sa-k8s]
}

resource "yandex_resourcemanager_folder_iam_member" "k8s_admin" {
 # Сервисному аккаунту "sa-k8s" назначается роль "admin".
 folder_id = var.folder_id
 role      = "k8s.admin"
 member    = "serviceAccount:${yandex_iam_service_account.sa-k8s.id}"
 depends_on = [yandex_iam_service_account.sa-k8s]
}


# Create service account

resource "yandex_iam_service_account" "sa" {
  folder_id   = var.folder_id
  description = "Service account for terraform"
  name        = "sa"
}

resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
  # Сервисному аккаунту "sa" назначается роль "storage.editor"
  folder_id = var.folder_id
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "sa-kms-encrypt" {
  # Сервисному аккаунту "sa" назначается роль "kms.keys.encrypterDecrypter"
  folder_id = var.folder_id
  role      = "kms.keys.encrypterDecrypter"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}


resource "yandex_iam_service_account_static_access_key" "keys" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = "Access keys for object storage"
}
