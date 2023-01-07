module "instance" {
  for_each       = local.vms[terraform.workspace]
  source         = "../modules/"
  instance_count = each.value

  subnet_id     = module.vpc.subnet_ids[0]
  zone          = var.yc_region
  folder_id     = module.vpc.folder_id
  image         = "centos-8"
  platform_id   = "standard-v2"
  name          = each.key
  description   = "News App Demo"
  instance_role = "news,balancer"
  users         = "centos"
  cores         = local.news_cores[terraform.workspace]
  boot_disk     = local.type_disk[terraform.workspace]
  disk_size     = local.news_disk_size[terraform.workspace]
  nat           = "true"
  memory        = local.news_memory[terraform.workspace]
  core_fraction = "100"
  depends_on    = [
    module.vpc
  ]
}

