# Declaring variables for user-defined parameters

variable "token" {
  default = ""
} # export YC_TOKEN="YOUR_YC_TOKEN"

variable "cloud_id" {
} # export YC_CLOUD_ID="YOUR_YC_CLOUD_ID"

variable "folder_id" {
} # export YC_FOLDER_ID="YOUR_YC_FOLDER_ID"

variable "vm_user" {
  type    = string
  default = "vm-user"
}

variable "vm_user_nat" {
  type    = string
  default = "nat-user"
}

variable "ssh_key_path" {
  default = "~/.ssh/id_rsa.pub"
}

variable "internal_nat_ip" {
  type    = string
  default = "192.168.10.254"
}

# Adding other parameters

locals {
  network_name     = "my-vpc"
  subnet_name1     = "public-subnet"
  subnet_name2     = "private-subnet"
  sg_nat_name      = "nat-instance-sg"
  vm_private_name  = "private-vm"
  vm_public_name   = "public-vm"
  vm_nat_name      = "nat-instance"
  route_table_name = "nat-instance-route"
  nat_image_id     = "fd80mrhj8fl2oe87o4e1" # nat-instance-ubuntu
  vm_image_id      = "fd8t08ih94rivuk5q46j" # ubuntu-2004-lts
}
