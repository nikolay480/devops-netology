## Домашнее задание к занятию "3.8. Компьютерные сети, лекция 3"

1.

```
vagrant@vagrant:$ telnet route-views.routeviews.org
Trying 128.223.51.103...
Connected to route-views.routeviews.org.
Escape character is '^]'.
C
**********************************************************************
User Access Verification

Username: rviews
```

```bash
route-views>sh ip ro 178.46.36.10
Routing entry for 178.46.32.0/19
  Known via "bgp 6447", distance 20, metric 0
  Tag 2497, type external
  Last update from 202.232.0.2 7w0d ago
  Routing Descriptor Blocks:
  * 202.232.0.2, from 202.232.0.2, 7w0d ago
      Route metric is 0, traffic share count is 1
      AS Hops 2
      Route tag 2497
      MPLS label: none
```

**BGP (Border Gateway Protocol)** — это основной протокол динамической маршрутизации, который используется в Интернете.

Маршрутизаторы, использующие протокол BGP, обмениваются информацией о доступности сетей. Вместе с информацией о сетях
передаются различные атрибуты этих сетей, с помощью которых BGP выбирает лучший маршрут и настраиваются политики
маршрутизации.

```bash
route-views>sh bgp 178.46.36.10
BGP routing table entry for 178.46.32.0/19, version 2285990089
Paths: (23 available, best #22, table default)
  Not advertised to any peer
  Refresh Epoch 1
  3333 1103 12389
    193.0.0.56 from 193.0.0.56 (193.0.0.56)
      Origin IGP, localpref 100, valid, external
      path 7FE09A22B308 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  4901 6079 3356 12389
    162.250.137.254 from 162.250.137.254 (162.250.137.254)
      Origin IGP, localpref 100, valid, external
      Community: 65000:10100 65000:10300 65000:10400
      path 7FE0A6DDB240 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3267 12389
    194.85.40.15 from 194.85.40.15 (185.141.126.1)
      Origin IGP, metric 0, localpref 100, valid, external
      path 7FE0E65A79E8 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  8283 1299 12389
```

2.

создаем 2 файла в `/etc/systemd/network/`:

**10-dummy0.netdev**

```
[NetDev]
Name=dummy0
Kind=dummy
```

20-dummy0.network

```
[Match]
Name=dummy0

[Network]
Address=10.2.2.2/32
```

```bash
root@vagrant:/etc/systemd/network# systemctl restart systemd-networkd
root@vagrant:/etc/systemd/network# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:a2:6b:fd brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic eth0
       valid_lft 86397sec preferred_lft 86397sec
    inet6 fe80::a00:27ff:fea2:6bfd/64 scope link
       valid_lft forever preferred_lft forever
4: dummy0: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN group default qlen 1000
    link/ether 7e:f5:36:7a:89:07 brd ff:ff:ff:ff:ff:ff
    inet 10.2.2.2/32 scope global dummy0
       valid_lft forever preferred_lft forever
    inet6 fe80::7cf5:36ff:fe7a:8907/64 scope link
       valid_lft forever preferred_lft forever
```

```bash
vagrant@vagrant:~$ sudo ip route add 10.0.3.0/24 via 10.0.2.1
vagrant@vagrant:~$ sudo ip route add 10.0.5.0/24 via 10.0.2.1
vagrant@vagrant:~$ route
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
default         _gateway        0.0.0.0         UG    100    0        0 eth0
10.0.2.0        0.0.0.0         255.255.255.0   U     0      0        0 eth0
_gateway        0.0.0.0         255.255.255.255 UH    100    0        0 eth0
10.0.3.0        10.0.2.1        255.255.255.0   UG    0      0        0 eth0
10.0.5.0        10.0.2.1        255.255.255.0   UG    0      0        0 eth0
```

3.

Открыты порты 53 и 22:

* Порт 53 использутся процессом systemd-resolve, который работает как распознаватель для DNS.
* Порт 22 используется для ssh-соединения.

```bash
vagrant@vagrant:~$ sudo netstat -plnt
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
tcp        0      0 127.0.0.53:53           0.0.0.0:*               LISTEN      659/systemd-resolve
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      925/sshd: /usr/sbin
tcp6       0      0 :::22                   :::*                    LISTEN      925/sshd: /usr/sbin   
```

4.

Открыты UDP-порты 53 и 68:

* Порт 53 использутся процессом systemd-resolve (как и TCP-port), который работает как распознаватель для DNS.
* Порт 68 используется процесом systemd-networkd.

**systemd-networkd** — системный демон для управления сетевыми настройками. Его задачей является обнаружение и настройка
сетевых устройств по мере их появления, а также создание виртуальных сетевых устройств

```bash
vagrant@vagrant:~$ sudo netstat -plnu
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
udp        0      0 127.0.0.53:53           0.0.0.0:*                           659/systemd-resolve
udp        0      0 10.0.2.15:68            0.0.0.0:*                           19059/systemd-netwo
```

5.

![](../../images/diagramma.png)
