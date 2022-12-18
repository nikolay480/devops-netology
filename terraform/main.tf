// Configure the Yandex.Cloud provider
provider "yandex" {
  # token     = "YC_TOKEN"
  # cloud_id  = "YC_CLOUD_ID"
  # folder_id = "YC_FOLDER_ID"
}

// Create a new instance

resource "yandex_compute_instance" "vm-centos" {
  name                      = "test1"
  zone                      = "ru-central1-a"
  allow_stopping_for_update = true

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd84grruhvq2be8986bl"
      type     = "network-nvme"
      size     = "20"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.my_subnet.id
    nat       = true
  }

  metadata = {
    ssh-keys = "centos:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_vpc_network" "my_network" {
  name = "net_terraform"
}

resource "yandex_vpc_subnet" "my_subnet" {
  name           = "sub_terraform"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.my_network.id
  v4_cidr_blocks = ["192.168.100.0/24"]
}
