resource "yandex_mdb_mysql_cluster" "mysql" {
  name                = "mysql" # "<имя кластера>"
  environment         = "PRESTABLE" # "<окружение, PRESTABLE или PRODUCTION>"
  network_id          = yandex_vpc_network.my-vpc.id # "<идентификатор сети>"
  version             = "8.0" # "<версия MySQL: 5.7 или 8.0>"
  security_group_ids  = [ yandex_vpc_security_group.nat-instance-sg.id ]
  deletion_protection = true # <защита от удаления кластера: true или false>
  maintenance_window {
    type = "WEEKLY" # <тип технического обслуживания: ANYTIME или WEEKLY>
    day  = "SUN" #<день недели для типа WEEKLY>
    hour = 06 #<час дня для типа WEEKLY>
  }
  backup_window_start {
    hours   = 23 #<час начала резервного копирования>
    minutes = 59 #<минута начала резервного копирования>
  }

  resources {
    resource_preset_id = "b1.medium" #"<класс хоста>"
    disk_type_id       = "network-ssd" #"<тип диска>"
    disk_size          = 20 # "<размер хранилища в гигабайтах>"
  }

  host {
    name             = "node-a1"
    zone             = "ru-central1-a"
    subnet_id        = yandex_vpc_subnet.private-subnet-a.id
    assign_public_ip = false # <публичный доступ к хосту: true или false>
  }
   host {
    name             = "node-b1"
    zone             = "ru-central1-b"
    subnet_id        = yandex_vpc_subnet.private-subnet-b.id
    assign_public_ip = false # <публичный доступ к хосту: true или false>
    priority         = 35 # <приоритет при выборе нового хоста-мастера: от 0 до 100>
    backup_priority  = 5 # <приоритет для резервного копирования: от 0 до 100>
  }
   host {
    name             = "node-b2"
    zone             = "ru-central1-b"
    subnet_id        = yandex_vpc_subnet.private-subnet-b.id
    assign_public_ip = false # <публичный доступ к хосту: true или false>
    backup_priority  = 10 # <приоритет для резервного копирования: от 0 до 100>
  }
}

resource "yandex_mdb_mysql_database" "netology_db" {
  cluster_id = yandex_mdb_mysql_cluster.mysql.id
  name       = "netology_db" #<имя БД>
}

resource "yandex_mdb_mysql_user" "user-db" {
  cluster_id = yandex_mdb_mysql_cluster.mysql.id
  name       = "user-db"
  password   = "user1user1"
  permission {
    database_name = yandex_mdb_mysql_database.netology_db.name
    roles         = ["ALL"]
  }
}
