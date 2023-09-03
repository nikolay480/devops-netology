## Managed Service for Kubernetes
resource "yandex_kubernetes_cluster" "k8s-regional" {
  name        = "k8s-regional"
  description = "cluster for k8s"

  network_id = yandex_vpc_network.my-vpc.id

  master {
    regional {
      region = "ru-central1"
      location {
        zone      = "${yandex_vpc_subnet.public-subnet-a.zone}"
        subnet_id = "${yandex_vpc_subnet.public-subnet-a.id}"
      }
      location {
        zone      = "${yandex_vpc_subnet.public-subnet-b.zone}"
        subnet_id = "${yandex_vpc_subnet.public-subnet-b.id}"
      }
      location {
        zone      = "${yandex_vpc_subnet.public-subnet-c.zone}"
        subnet_id = "${yandex_vpc_subnet.public-subnet-c.id}"
      }
    }
    version   = "1.25"
    security_group_ids = [
      yandex_vpc_security_group.k8s_master.id,
      yandex_vpc_security_group.internal.id
    ]
    public_ip = true
    maintenance_policy {
      auto_upgrade = true
      maintenance_window {
        day        = "friday"
        start_time = "10:00"
        duration   = "4h30m"
      }
    } 
  }

  kms_provider {
      key_id = "${yandex_kms_symmetric_key.kms-key.id}"
    }
  service_account_id      = yandex_iam_service_account.sa-k8s.id
  node_service_account_id = yandex_iam_service_account.sa-k8s.id
  
  depends_on = [
   yandex_iam_service_account.sa-k8s,
   yandex_resourcemanager_folder_iam_member.editor,
   yandex_resourcemanager_folder_iam_member.images-puller,
   yandex_resourcemanager_folder_iam_member.k8s_admin 
  ]
  # labels = {
  #   my_key       = "my_value"
  #   my_other_key = "my_other_value"
  # }

  release_channel = "STABLE"
}
