output "internal_ip_address_vm-test_yandex_cloud" {
  value = "${yandex_compute_instance.vm-test[*].network_interface[*].ip_address}"
}

output "external_ip_address_vm-test_yandex_cloud" {
  value = "${yandex_compute_instance.vm-test[*].network_interface[*].nat_ip_address}"
}
