
resource "yandex_iam_service_account" "ig-sa" {
  name        = "ig-sa"
  description = "service account to manage IG"
}

resource "yandex_resourcemanager_folder_iam_member" "editor" {
  folder_id = var.folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.ig-sa.id}"
}

resource "yandex_resourcemanager_folder_iam_binding" "editor" {
  folder_id = var.folder_id
  role      = "editor"
  members = [
    "serviceAccount:${yandex_iam_service_account.ig-sa.id}",
  ]
  depends_on = [
    yandex_iam_service_account.ig-sa,
  ]
}

resource "yandex_compute_instance_group" "ig-1" {
  name                = "fixed-ig-with-balancer"
  folder_id           = var.folder_id
  service_account_id  = yandex_iam_service_account.ig-sa.id
  deletion_protection = false # защита_от_удаления:_true_или_false
  depends_on = [
    yandex_resourcemanager_folder_iam_binding.editor,
  yandex_resourcemanager_folder_iam_member.editor, ]
  instance_template {
    platform_id = "standard-v3"
    name        = "site-web-{instance.index}-{instance.short_id}"
    resources {
      memory = 2 # объем_RAM_в_ГБ
      cores  = 2 # количество_ядер_vCPU
    }

    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = "fd827b91d99psvq5fjit"
      }
    }

    network_interface {
      subnet_ids = [yandex_vpc_subnet.public-subnet.id]
    }
    metadata = {
      user-data = file("./files/config.yaml")
    }
    # }
    #   metadata = { user-data = "#cloud-config\nusers:\n  - name: ${var.vm_user}\n    groups: sudo\n    shell: /bin/bash\n    sudo: ['ALL=(ALL) NOPASSWD:ALL']\n    ssh-authorized-keys:\n      - ${file("${var.ssh_key_path}")}"
    # }
  }
  scale_policy {
    fixed_scale {
      size = 3 # количество_ВМ_в_группе
    }
  }
  allocation_policy {
    zones = ["ru-central1-a"]
  }
  deploy_policy {
    max_unavailable = 1
    max_expansion   = 0
  }
  load_balancer {
    target_group_name        = "target-group"
    target_group_description = "load balancer target group"
  }
}

resource "yandex_lb_network_load_balancer" "lb-1" {
  name = "network-load-balancer-1"

  listener {
    name = "network-load-balancer-1-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_compute_instance_group.ig-1.load_balancer.0.target_group_id

    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/index.html"
      }
    }
  }
}


