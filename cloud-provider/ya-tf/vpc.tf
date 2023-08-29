# Creating a cloud network

resource "yandex_vpc_network" "my-vpc" {
  name = local.network_name
}

# Creating subnets

resource "yandex_vpc_subnet" "public-subnet" {
  name           = local.subnet_name1
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.my-vpc.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_vpc_subnet" "private-subnet" {
  name           = local.subnet_name2
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.my-vpc.id
  v4_cidr_blocks = ["192.168.20.0/24"]
  route_table_id = yandex_vpc_route_table.nat-instance-route.id
}

# Creating a route table and static route

resource "yandex_vpc_route_table" "nat-instance-route" {
  name       = "nat-instance-route"
  network_id = yandex_vpc_network.my-vpc.id
  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = yandex_compute_instance.nat-instance.network_interface.0.ip_address
  }
}
