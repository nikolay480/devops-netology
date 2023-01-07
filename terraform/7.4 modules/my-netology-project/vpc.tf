module "vpc" {
  source  = "github.com/hamnsk/terraform-yandex-vpc?ref=master"
  description = "managed by terraform"
  create_folder = length(var.yc_folder_id) > 0 ? false : true
  yc_folder_id = var.yc_folder_id
  name = terraform.workspace
  subnets = local.vpc_subnets[terraform.workspace]
}
