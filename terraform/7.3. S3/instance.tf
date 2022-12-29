// Create a new instance

resource "yandex_compute_instance" "vm-test" {
  count                     = local.new_instance_count[terraform.workspace]
  name                      = "srv-${count.index+1}"
  platform_id               = local.instance_platform_id[terraform.workspace]
  zone                      = "ru-central1-a"
  allow_stopping_for_update = true

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      # CentOS8 base image"
      image_id = "fd84grruhvq2be8986bl"
      type     = local.type_disk[terraform.workspace]
      size     = "20"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet_terraform.id
    nat       = true
  }

  metadata = {
    ssh-keys = "centos:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_compute_instance" "vm-test-new" {
    for_each = local.vms[terraform.workspace]
    name = each.key


    resources {
        cores  = local.news_cores[terraform.workspace]
        memory = local.news_memory[terraform.workspace]
    }

    boot_disk {
        initialize_params {
      # CentOS8 base image"
            image_id = "fd84grruhvq2be8986bl"
            type     = local.type_disk[terraform.workspace]
            size     = local.news_disk_size[terraform.workspace]
        }
    }
    network_interface {
        subnet_id = yandex_vpc_subnet.subnet_terraform.id
        nat       = true
    }

    metadata = {
    ssh-keys = "centos:${file("~/.ssh/id_rsa.pub")}"
    }

    lifecycle {
        create_before_destroy = true
    }
}

resource "yandex_vpc_network" "network_terraform" {
  name = "net_terraform"
}

resource "yandex_vpc_subnet" "subnet_terraform" {
  name           = "sub_terraform"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network_terraform.id
  v4_cidr_blocks = ["192.168.15.0/24"]
}