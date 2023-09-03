resource "yandex_kubernetes_node_group" "k8s_node_group" {
  cluster_id  = "${yandex_kubernetes_cluster.k8s-regional.id}"
  name        = "k8s-node-group"
  description = "node group for k8s"
  version     = "1.25"

#   labels = {
#     "key" = "value"
#   }

  instance_template {
    name        = "node-{instance.short_id}-{instance_group.id}"
    platform_id = "standard-v1"
    network_interface {
      nat        = true
      security_group_ids = [
        yandex_vpc_security_group.k8s_worker.id,
        yandex_vpc_security_group.internal.id
      ]
      subnet_ids = ["${yandex_vpc_subnet.public-subnet-a.id}"]
    }
    resources {
      memory = 2
      cores  = 2
    }
    boot_disk {
      type = "network-hdd"
      size = 30
    }
    scheduling_policy {
      preemptible = true
    }
    container_runtime {
      type = "containerd"
    }
    metadata    = {
      user-data = "#cloud-config\nusers:\n  - name: ${var.vm_user}\n    groups: sudo\n    shell: /bin/bash\n    sudo: ['ALL=(ALL) NOPASSWD:ALL']\n    ssh-authorized-keys:\n      - ${file("${var.ssh_key_path}")}"
    }
  }
  scale_policy {
    auto_scale {
      min     = 3
      max     = 6
      initial = 3
    }
  }
  allocation_policy {
    location {
      zone = "ru-central1-a"
    }
  }
  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true
    maintenance_window {
      day        = "monday"
      start_time = "15:00"
      duration   = "3h"
    }
    maintenance_window {
      day        = "friday"
      start_time = "10:00"
      duration   = "4h30m"
    }
  }
  depends_on = [
    yandex_kms_symmetric_key_iam_binding.viewer,
    yandex_resourcemanager_folder_iam_member.editor,
    yandex_resourcemanager_folder_iam_member.images-puller,
    yandex_resourcemanager_folder_iam_member.k8s_admin
  ]
}