output "internal_ip_address_vm-test1_yandex_cloud" {
  value = "${yandex_compute_instance.vm-centos.network_interface.0.ip_address}"
}

output "external_ip_address_vm-test1_yandex_cloud" {
  value = "${yandex_compute_instance.vm-centos.network_interface.0.nat_ip_address}"
}

output "subnet_id" {
  value = "${yandex_vpc_subnet.my_subnet.id}"
}