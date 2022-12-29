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
        prod = "nerwork-ssd"
    }
}