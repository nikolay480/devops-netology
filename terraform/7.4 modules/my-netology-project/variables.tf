variable "yc_token" {
   default = ""
}

variable "yc_cloud_id" {
  default = ""
}

variable "yc_folder_id" {
  default = ""
}

variable "yc_region" {
  default = "ru-central1-a"
}

locals {
    vms = {
        stage = {"web1"=1, "db1" = 1}
        prod = {"web-1"=1, "web-2"=1, "db-1"=1, "db-2" =1}
    }
    instance_platform_id = {
        default = "standard-v1"
        stage = "standard-v1"
	    prod   = "standard-v2"
    }
    new_instance_count = {
        default = 1
	    stage = 1
	    prod   = 2
	}
    news_cores = {
        default = 2
        stage = 2
        prod = 2
    }
    news_memory = {
        default = 1
        stage = 2
        prod = 4
    }
    news_disk_size = {
        default = 20
        stage = 25
        prod = 40
    }
    type_disk = {
        default = "network-hdd"
        stage = "network-hdd"
        prod = "network-ssd"
    }

    vpc_subnets = {
      default = [
        {
          "v4_cidr_blocks" : [
            "10.185.0.0/24"
          ],
          "zone" : var.yc_region
        }
      ]
      stage = [
        {
          "v4_cidr_blocks" : [
            "10.186.0.0/24"
          ],
          "zone" : var.yc_region
        }
      ]
      prod = [
        {
          zone           = "ru-central1-a"
          v4_cidr_blocks = ["10.187.0.0/24"]
        },
        {
          zone           = "ru-central1-b"
          v4_cidr_blocks = ["10.188.0.0/24"]
        },
        {
          zone           = "ru-central1-c"
          v4_cidr_blocks = ["10.189.0.0/24"]
        }
      ]
    }
}
