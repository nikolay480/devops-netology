# Creating a security group

resource "yandex_vpc_security_group" "nat-instance-sg" {
  name       = local.sg_nat_name
  network_id = yandex_vpc_network.my-vpc.id

  egress {
    protocol       = "ANY"
    description    = "any"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    description    = "ssh"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }

  ingress {
    protocol       = "TCP"
    description    = "ext-http"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  ingress {
    protocol       = "TCP"
    description    = "ext-https"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 443
  }
  ingress {
    protocol       = "TCP"
    description    = "mysql-client"
    v4_cidr_blocks = [ "0.0.0.0/0" ]
    port           = 3306
  }
}

resource "yandex_vpc_security_group" "internal" {
  name        = "internal"
  description = "Managed by terraform"
  network_id  = yandex_vpc_network.my-vpc.id
  labels = {
    firewall = "yc_internal"
  }
  ingress {
    protocol          = "ANY"
    description       = "self"
    predefined_target = "self_security_group"
    v4_cidr_blocks = [ "0.0.0.0/0" ]
    from_port         = 0
    to_port           = 65535
  }
  egress {
    protocol          = "ANY"
    description       = "self"
    predefined_target = "self_security_group"
    v4_cidr_blocks = [ "0.0.0.0/0" ]
    from_port         = 0
    to_port           = 65535
  }
}

resource "yandex_vpc_security_group" "k8s_master" {
  name        = "k8s-master"
  description = "Managed by terraform"
  network_id  = yandex_vpc_network.my-vpc.id
  labels = {
    firewall = "k8s-master"
  }
  ingress {
    protocol       = "TCP"
    description    = "access to api k8s"
    v4_cidr_blocks = var.white_ips_for_master
    port           = 443
  }
  ingress {
    protocol       = "TCP"
    description    = "access for monitoring"
    v4_cidr_blocks = var.white_ips_for_master
    port           = 4443
  }
  ingress {
    protocol       = "TCP"
    description    = "access for monitoring"
    v4_cidr_blocks = var.white_ips_for_master
    port           = 64443
  }

  ingress {
    protocol          = "TCP"
    description       = "access to api k8s from Yandex lb"
    predefined_target = "loadbalancer_healthchecks"
    from_port         = 0
    to_port           = 65535
  }
}

resource "yandex_vpc_security_group" "k8s_worker" {
  name        = "k8s-worker"
  description = "Managed by terraform"
  network_id  = yandex_vpc_network.my-vpc.id
  labels = {
    firewall = "k8s-worker"
  }
  ingress {
    protocol       = "ANY"
    description    = "any connections"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
  egress {
    protocol       = "ANY"
    description    = "any connections"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}