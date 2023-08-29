output "static-key-access-key" {
  description = "Access key for admin user"
  value       = yandex_iam_service_account_static_access_key.static-access-key.access_key
  sensitive = true
}

output "static-key-secret-key" {
  description = "Secret key for admin user"
  value       = yandex_iam_service_account_static_access_key.static-access-key.secret_key
  sensitive = true
}
