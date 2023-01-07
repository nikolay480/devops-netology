output "public_ip" {
  value = {
  for k, v in module.instance : k => v.instance_public_ip
  }
}