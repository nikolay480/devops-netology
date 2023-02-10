## Домашнее задание к занятию "3.5. Файловые системы"

# Домашнее задание к занятию "Файловые системы"

### Цель задания

В результате выполнения этого задания вы: 

1. Научитесь работать с инструментами разметки жестких дисков, виртуальных разделов - RAID массивами и логическими томами, конфигурациями файловых систем. Основная задача - понять, какие слои абстракций могут нас отделять от файловой системы до железа. Обычно инженер инфраструктуры не сталкивается напрямую с настройкой LVM или RAID, но иметь понимание, как это работает - необходимо.
1. Создадите нештатную ситуацию работы жестких дисков и поймете, как система RAID обеспечивает отказоустойчивую работу.

<details>

### Чеклист готовности к домашнему заданию

1. Убедитесь, что у вас на новой виртуальной машине (шаг 3 задания) установлены следующие утилиты - `mdadm`, `fdisk`, `sfdisk`, `mkfs`, `lsblk`, `wget`.  
2. Воспользуйтесь пакетным менеджером apt для установки необходимых инструментов


### Инструменты/ дополнительные материалы, которые пригодятся для выполнения задания

1. Разряженные файлы - [sparse](https://ru.wikipedia.org/wiki/%D0%A0%D0%B0%D0%B7%D1%80%D0%B5%D0%B6%D1%91%D0%BD%D0%BD%D1%8B%D0%B9_%D1%84%D0%B0%D0%B9%D0%BB)
2. [Подробный анализ производительности RAID,3-19 страницы](https://www.baarf.dk/BAARF/0.Millsap1996.08.21-VLDB.pdf).
3. [RAID5 write hole](https://www.intel.com/content/www/us/en/support/articles/000057368/memory-and-storage.html).

</details>

------

## Задание

1. Узнайте о [sparse](https://ru.wikipedia.org/wiki/%D0%A0%D0%B0%D0%B7%D1%80%D0%B5%D0%B6%D1%91%D0%BD%D0%BD%D1%8B%D0%B9_%D1%84%D0%B0%D0%B9%D0%BB) (разряженных) файлах.

_Разрежённый файл_ (англ. sparse file) — файл, в котором последовательности нулевых байтов
заменены на информацию об этих последовательностях (список дыр).

_Дыра_ (англ. hole) — последовательность нулевых байт внутри файла, не записанная на диск.
Информация о дырах (смещение от начала файла в байтах и количество байт) хранится в метаданных ФС.

**Преимущества:**

* экономия дискового пространства. Использование разрежённых файлов считается одним из способов сжатия данных на уровне
  файловой системы;

* отсутствие временных затрат на запись нулевых байт;

* увеличение срока службы запоминающих устройств.

##### **Разрежённые файлы используются для хранения контейнеров**, например:
- образов дисков виртуальных машин;
- резервных копий дисков и/или разделов, созданных спец. ПО.

1. Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?

**Нет.**
В Linux каждый файл имеет уникальный идентификатор - **индексный дескриптор (inode)**. Это число, которое однозначно
идентифицирует файл в файловой системе.

  Жесткая ссылка и файл, для которой она создавалась, имеют одинаковые **inode**. Поэтому жесткая ссылка имеет те же
права доступа, владельца и время последней модификации, что и целевой файл.

Различаются только имена файлов. Фактически жесткая ссылка это еще одно имя для файла.

3. Сделайте `vagrant destroy` на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile следующим:

    ```ruby
    path_to_disk_folder = './disks'

    host_params = {
        'disk_size' => 2560,
        'disks'=>[1, 2],
        'cpus'=>2,
        'memory'=>2048,
        'hostname'=>'sysadm-fs',
        'vm_name'=>'sysadm-fs'
    }
    Vagrant.configure("2") do |config|
        config.vm.box = "bento/ubuntu-20.04"
        config.vm.hostname=host_params['hostname']
        config.vm.provider :virtualbox do |v|

            v.name=host_params['vm_name']
            v.cpus=host_params['cpus']
            v.memory=host_params['memory']

            host_params['disks'].each do |disk|
                file_to_disk=path_to_disk_folder+'/disk'+disk.to_s+'.vdi'
                unless File.exist?(file_to_disk)
                    v.customize ['createmedium', '--filename', file_to_disk, '--size', host_params['disk_size']]
                end
                v.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', disk.to_s, '--device', 0, '--type', 'hdd', '--medium', file_to_disk]
            end
        end
        config.vm.network "private_network", type: "dhcp"
    end
    ```

    Данная конфигурация создаст новую виртуальную машину с двумя дополнительными неразмеченными дисками по 2.5 Гб.
Выполнено. Создана новая виртуальная машина с двумя дополнительными неразмеченными дисками по 2.5 Гб.

```sh
vagrant@vagrant:~$ lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
loop0                       7:0    0 67.2M  1 loop /snap/lxd/21835
loop1                       7:1    0 61.9M  1 loop /snap/core20/1328
loop2                       7:2    0 43.6M  1 loop /snap/snapd/14978
sda                         8:0    0   64G  0 disk
├─sda1                      8:1    0    1M  0 part
├─sda2                      8:2    0  1.5G  0 part /boot
└─sda3                      8:3    0 62.5G  0 part
  └─ubuntu--vg-ubuntu--lv 253:0    0 31.3G  0 lvm  /
sdb                         8:16   0  2.5G  0 disk
sdc                         8:32   0  2.5G  0 disk`
```

4. Используя `fdisk`, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.
```sh
vagrant@vagrant:~$ sudo -i
root@vagrant:~# fdisk /dev/sdb

Welcome to fdisk (util-linux 2.34).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table.
Created a new DOS disklabel with disk identifier 0x87ca6434.```

Command (m for help): n
Partition type
   p   primary (0 primary, 0 extended, 4 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (1-4, default 1): 1
First sector (2048-5242879, default 2048): 2048
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-5242879, default 5242879): +2G

Created a new partition 1 of type 'Linux' and of size 2 GiB.

Command (m for help): n
Partition type
   p   primary (1 primary, 0 extended, 3 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (2-4, default 2): 2
First sector (4196352-5242879, default 4196352):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (4196352-5242879, default 5242879):

Created a new partition 2 of type 'Linux' and of size 511 MiB.

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
```
```bash
root@vagrant:~# lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
loop0                       7:0    0 67.2M  1 loop /snap/lxd/21835
loop1                       7:1    0 61.9M  1 loop /snap/core20/1328
loop2                       7:2    0 43.6M  1 loop /snap/snapd/14978
loop3                       7:3    0   48M  1 loop /snap/snapd/16778
loop4                       7:4    0 63.2M  1 loop /snap/core20/1623
loop5                       7:5    0 67.8M  1 loop /snap/lxd/22753
sda                         8:0    0   64G  0 disk
├─sda1                      8:1    0    1M  0 part
├─sda2                      8:2    0  1.5G  0 part /boot
└─sda3                      8:3    0 62.5G  0 part
  └─ubuntu--vg-ubuntu--lv 253:0    0 31.3G  0 lvm  /
sdb                         8:16   0  2.5G  0 disk
├─sdb1                      8:17   0    2G  0 part
└─sdb2                      8:18   0  511M  0 part
sdc                         8:32   0  2.5G  0 disk
```
6. Используя `sfdisk`, перенесите данную таблицу разделов на второй диск.
```bash
root@vagrant:~# sfdisk -d /dev/sdb | sfdisk -f /dev/sdc
Checking that no-one is using this disk right now ... OK

Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes

>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Created a new DOS disklabel with disk identifier 0x87ca6434.
/dev/sdc1: Created a new partition 1 of type 'Linux' and of size 2 GiB.
/dev/sdc2: Created a new partition 2 of type 'Linux' and of size 511 MiB.
/dev/sdc3: Done.

New situation:
Disklabel type: dos
Disk identifier: 0x87ca6434

Device     Boot   Start     End Sectors  Size Id Type
/dev/sdc1          2048 4196351 4194304    2G 83 Linux
/dev/sdc2       4196352 5242879 1046528  511M 83 Linux

The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
```

```bash
root@vagrant:~# lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
loop0                       7:0    0 67.2M  1 loop /snap/lxd/21835
loop1                       7:1    0 61.9M  1 loop /snap/core20/1328
loop2                       7:2    0 43.6M  1 loop /snap/snapd/14978
loop3                       7:3    0   48M  1 loop /snap/snapd/16778
loop4                       7:4    0 63.2M  1 loop /snap/core20/1623
loop5                       7:5    0 67.8M  1 loop /snap/lxd/22753
sda                         8:0    0   64G  0 disk
├─sda1                      8:1    0    1M  0 part
├─sda2                      8:2    0  1.5G  0 part /boot
└─sda3                      8:3    0 62.5G  0 part
  └─ubuntu--vg-ubuntu--lv 253:0    0 31.3G  0 lvm  /
sdb                         8:16   0  2.5G  0 disk
├─sdb1                      8:17   0    2G  0 part
└─sdb2                      8:18   0  511M  0 part
sdc                         8:32   0  2.5G  0 disk
├─sdc1                      8:33   0    2G  0 part
└─sdc2                      8:34   0  511M  0 part
```

7. Соберите `mdadm` RAID1 на паре разделов 2 Гб.

```bash
root@vagrant:~# mdadm --create --verbose /dev/md0 --level=1 --raid-devices=2 /dev/sd{b1,c1}
mdadm: Note: this array has metadata at the start and
    may not be suitable as a boot device.  If you plan to
    store '/boot' on this device please ensure that
    your boot-loader understands md/v1.x metadata, or use
    --metadata=0.90
mdadm: size set to 2094080K
Continue creating array? Y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.
```

8. Соберите `mdadm` RAID0 на второй паре маленьких разделов.

```bash
root@vagrant:~# mdadm --create --verbose /dev/md1 --level=0 --raid-devices=2 /dev/sd{b2,c2}
mdadm: chunk size defaults to 512K
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md1 started.
```

```bash
root@vagrant:~# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
md1 : active raid0 sdc2[1] sdb2[0]
      1042432 blocks super 1.2 512k chunks

md0 : active raid1 sdc1[1] sdb1[0]
      2094080 blocks super 1.2 [2/2] [UU]

unused devices: <none>
```

9. Создайте 2 независимых PV на получившихся md-устройствах.
```bash
root@vagrant:~# pvcreate /dev/md0
  Physical volume "/dev/md0" successfully created.
root@vagrant:~# pvcreate /dev/md1
  Physical volume "/dev/md1" successfully created.
```
10. Создайте общую volume-group на этих двух PV.

```bash
root@vagrant:~# vgcreate VG0 /dev/md0 /dev/md1
  Volume group "VG0" successfully created
```

11. Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.

```bash
root@vagrant:~# lvcreate -L 100M VG0 /dev/md1
  Logical volume "lvol0" created.
```

12. Создайте `mkfs.ext4` ФС на получившемся LV.
```bash
root@vagrant:~# mkfs.ext4 /dev/VG0/lvol0
mke2fs 1.45.5 (07-Jan-2020)
Creating filesystem with 25600 4k blocks and 25600 inodes

Allocating group tables: done
Writing inode tables: done
Creating journal (1024 blocks): done
Writing superblocks and filesystem accounting information: done
```
13. Смонтируйте этот раздел в любую директорию, например, `/tmp/new`.
```bash
root@vagrant:~# mkdir /tmp/new
root@vagrant:~# mount /dev/VG0/lvol0 /tmp/new
```

```bash
root@vagrant:~# cat /proc/mounts | grep /tmp/new
/dev/mapper/VG0-lvol0 /tmp/new ext4 rw,relatime,stripe=256 0 0
```

14. Поместите туда тестовый файл, например `wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz`.
```bash
root@vagrant:~# wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz
--2022-09-20 13:41:25--  https://mirror.yandex.ru/ubuntu/ls-lR.gz
Resolving mirror.yandex.ru (mirror.yandex.ru)... 213.180.204.183, 2a02:6b8::183
Connecting to mirror.yandex.ru (mirror.yandex.ru)|213.180.204.183|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 22382846 (21M) [application/octet-stream]
Saving to: ‘/tmp/new/test.gz’

/tmp/new/test.gz        100%[=============================>]  21.35M  4.77MB/s    in 5.0s

2022-09-20 13:41:31 (4.30 MB/s) - ‘/tmp/new/test.gz’ saved [22382846/22382846]

root@vagrant:~# ls /tmp/new
lost+found  test.gz
```
15. Прикрепите вывод `lsblk`.
```bash
root@vagrant:~# lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
loop0                       7:0    0 67.2M  1 loop  /snap/lxd/21835
loop1                       7:1    0 61.9M  1 loop  /snap/core20/1328
loop2                       7:2    0 43.6M  1 loop  /snap/snapd/14978
loop3                       7:3    0   48M  1 loop  /snap/snapd/16778
loop4                       7:4    0 63.2M  1 loop  /snap/core20/1623
loop5                       7:5    0 67.8M  1 loop  /snap/lxd/22753
sda                         8:0    0   64G  0 disk
├─sda1                      8:1    0    1M  0 part
├─sda2                      8:2    0  1.5G  0 part  /boot
└─sda3                      8:3    0 62.5G  0 part
  └─ubuntu--vg-ubuntu--lv 253:0    0 31.3G  0 lvm   /
sdb                         8:16   0  2.5G  0 disk
├─sdb1                      8:17   0    2G  0 part
│ └─md0                     9:0    0    2G  0 raid1
└─sdb2                      8:18   0  511M  0 part
  └─md1                     9:1    0 1018M  0 raid0
    └─VG0-lvol0           253:1    0  100M  0 lvm   /tmp/new
sdc                         8:32   0  2.5G  0 disk
├─sdc1                      8:33   0    2G  0 part
│ └─md0                     9:0    0    2G  0 raid1
└─sdc2                      8:34   0  511M  0 part
  └─md1                     9:1    0 1018M  0 raid0
    └─VG0-lvol0           253:1    0  100M  0 lvm   /tmp/new
```
16. Протестируйте целостность файла:
    
```bash
root@vagrant:~# gzip -t /tmp/new/test.gz
root@vagrant:~# echo $?
0
```
17. Используя `pvmove`, переместите содержимое PV с RAID0 на RAID1.
```bash
root@vagrant:~# pvmove /dev/md1 /dev/md0
  /dev/md1: Moved: 12.00%
  /dev/md1: Moved: 100.00%
root@vagrant:~# lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
loop0                       7:0    0 67.2M  1 loop  /snap/lxd/21835
loop1                       7:1    0 61.9M  1 loop  /snap/core20/1328
loop2                       7:2    0 43.6M  1 loop  /snap/snapd/14978
loop3                       7:3    0   48M  1 loop  /snap/snapd/16778
loop4                       7:4    0 63.2M  1 loop  /snap/core20/1623
loop5                       7:5    0 67.8M  1 loop  /snap/lxd/22753
sda                         8:0    0   64G  0 disk
├─sda1                      8:1    0    1M  0 part
├─sda2                      8:2    0  1.5G  0 part  /boot
└─sda3                      8:3    0 62.5G  0 part
  └─ubuntu--vg-ubuntu--lv 253:0    0 31.3G  0 lvm   /
sdb                         8:16   0  2.5G  0 disk
├─sdb1                      8:17   0    2G  0 part
│ └─md0                     9:0    0    2G  0 raid1
│   └─VG0-lvol0           253:1    0  100M  0 lvm   /tmp/new
└─sdb2                      8:18   0  511M  0 part
  └─md1                     9:1    0 1018M  0 raid0
sdc                         8:32   0  2.5G  0 disk
├─sdc1                      8:33   0    2G  0 part
│ └─md0                     9:0    0    2G  0 raid1
│   └─VG0-lvol0           253:1    0  100M  0 lvm   /tmp/new
└─sdc2                      8:34   0  511M  0 part
  └─md1                     9:1    0 1018M  0 raid0
```

18. Сделайте `--fail` на устройство в вашем RAID1 md.
```bash
root@vagrant:~# mdadm --fail /dev/md0 /dev/sdb1
mdadm: set /dev/sdb1 faulty in /dev/md0
root@vagrant:~# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
md1 : active raid0 sdc2[1] sdb2[0]
      1042432 blocks super 1.2 512k chunks

md0 : active raid1 sdc1[1] sdb1[0](F)
      2094080 blocks super 1.2 [2/1] [_U]

unused devices: <none>
```
19. Подтвердите выводом `dmesg`, что RAID1 работает в деградированном состоянии.
```bash
root@vagrant:~# dmesg -T | grep md0
[Tue Sep 20 12:16:35 2022] md/raid1:md0: not clean -- starting background reconstruction
[Tue Sep 20 12:16:35 2022] md/raid1:md0: active with 2 out of 2 mirrors
[Tue Sep 20 12:16:35 2022] md0: detected capacity change from 0 to 2144337920
[Tue Sep 20 12:16:35 2022] md: resync of RAID array md0
[Tue Sep 20 12:16:45 2022] md: md0: resync done.
[Tue Sep 20 14:02:45 2022] md/raid1:md0: Disk failure on sdb1, disabling device.
                           md/raid1:md0: Operation continuing on 1 devices.
```
20. Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен:

```bash
root@vagrant:~# gzip -t /tmp/new/test.gz
root@vagrant:~# echo $?
0
```

21. Погасите тестовый хост, `vagrant destroy`.

Выполнено.
 
---

