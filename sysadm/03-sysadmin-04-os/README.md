## Домашнее задание к занятию "3.4. Операционные системы, лекция 2"

### Цель задания

В результате выполнения этого задания вы:

1. Познакомитесь со средством сбора метрик node_exporter и средством сбора и визуализации метрик NetData. Такого рода
   инструменты позволяют выстроить систему мониторинга сервисов для своевременного выявления проблем в их работе.
2. Построите простой systemd unit файл для создания долгоживущих процессов, которые стартуют вместе со стартом системы
   автоматически.
3. Проанализируете dmesg, а именно часть лога старта виртуальной машины, чтобы понять, какая полезная информация может
   там находиться.
4. Поработаете с unshare и nsenter для понимания, как создать отдельный namespace для процесса (частичная
   контейнеризация).

<details>

### Чеклист готовности к домашнему заданию

1. Убедитесь, что у вас установлен [Netdata](https://github.com/netdata/netdata) c ресурса с
   предподготовленными [пакетами](https://packagecloud.io/netdata/netdata/install) или `sudo apt install -y netdata`.

### Инструменты/ дополнительные материалы, которые пригодятся для выполнения задания

1. [Документация](https://www.freedesktop.org/software/systemd/man/systemd.service.html) по systemd unit файлам
2. [Документация](https://www.kernel.org/doc/Documentation/sysctl/) по параметрам sysctl

</details>
------

## Задание

1. На лекции мы познакомились с [node_exporter](https://github.com/prometheus/node_exporter/releases). В демонстрации
   его исполняемый файл запускался в background. Этого достаточно для демо, но не для настоящей production-системы, где
   процессы должны находиться под внешним управлением. Используя знания из лекции по systemd, создайте самостоятельно
   простой [unit-файл](https://www.freedesktop.org/software/systemd/man/systemd.service.html) для node_exporter:

    * поместите его в автозагрузку,
    * предусмотрите возможность добавления опций к запускаемому процессу через внешний файл (посмотрите, например,
      на `systemctl cat cron`),
    * удостоверьтесь, что с помощью `systemctl` процесс корректно стартует, завершается, а после перезагрузки
      автоматически поднимается.

#### Cоздан unit-файл для Node Exporter:

```bash
root@vagrant:/etc/systemd/system# cat node_exporter.service

[Unit]
Description=Node Exporter
Wants=network.target
After=network.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter $OPTIONS
EnvironmentFile=/etc/default/node_exporter
ExecReload=/bin/kill -HUP $MAINPID
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

______

#### Node Exporter добавлен в автозагрузку:

```bash
root@vagrant:/etc/systemd/system$ sudo systemctl enable node_exporter
Created symlink /etc/systemd/system/multi-user.target.wants/node_exporter.service →
/etc/systemd/system/node_exporter.service.
```

_________________

#### Процесс корректно останавливается и запускается, после перезагрузки процесс запускается:

```bash

root@vagrant:/etc/systemd/system# systemctl status node_exporter.service
● node_exporter.service - Node Exporter
Loaded: loaded (/etc/systemd/system/node_exporter.service; enabled;>
Active: active (running) since Tue 2022-09-13 13:27:07 UTC; 28s ago
Main PID: 3182 (node_exporter)
Tasks: 5 (limit: 1066)
Memory: 2.5M
CGroup: /system.slice/node_exporter.service
└─3182 /usr/local/bin/node_exporter

Sep 13 13:27:07 vagrant node_exporter[3182]: ts=2022-09-13T13:27:07.784Z>
Sep 13 13:27:07 vagrant node_exporter[3182]: ts=2022-09-13T13:27:07.784Z>
Sep 13 13:27:07 vagrant node_exporter[3182]: ts=2022-09-13T13:27:07.784Z>
Sep 13 13:27:07 vagrant node_exporter[3182]: ts=2022-09-13T13:27:07.784Z>
Sep 13 13:27:07 vagrant node_exporter[3182]: ts=2022-09-13T13:27:07.784Z>
Sep 13 13:27:07 vagrant node_exporter[3182]: ts=2022-09-13T13:27:07.784Z>
Sep 13 13:27:07 vagrant node_exporter[3182]: ts=2022-09-13T13:27:07.784Z>
Sep 13 13:27:07 vagrant node_exporter[3182]: ts=2022-09-13T13:27:07.784Z>
Sep 13 13:27:07 vagrant node_exporter[3182]: ts=2022-09-13T13:27:07.785Z>
Sep 13 13:27:07 vagrant node_exporter[3182]: ts=2022-09-13T13:27:07.786Z>
```

```bash
root@vagrant:/etc/systemd/system# ps -e | grep node_exporter
3182 ? 00:00:00 node_exporter
```

```bash
root@vagrant:/etc/systemd/system# systemctl stop node_exporter.service
```

```bash
root@vagrant:/etc/systemd/system# systemctl status node_exporter.service
● node_exporter.service - Node Exporter
Loaded: loaded (/etc/systemd/system/node_exporter.service; enabled;>
Active: inactive (dead) since Tue 2022-09-13 13:30:08 UTC; 9s ago
Process: 3182 ExecStart=/usr/local/bin/node_exporter $OPTIONS (code=>
Main PID: 3182 (code=killed, signal=TERM)

Sep 13 13:27:07 vagrant node_exporter[3182]: ts=2022-09-13T13:27:07.784Z>
Sep 13 13:27:07 vagrant node_exporter[3182]: ts=2022-09-13T13:27:07.784Z>
Sep 13 13:27:07 vagrant node_exporter[3182]: ts=2022-09-13T13:27:07.784Z>
Sep 13 13:27:07 vagrant node_exporter[3182]: ts=2022-09-13T13:27:07.784Z>
Sep 13 13:27:07 vagrant node_exporter[3182]: ts=2022-09-13T13:27:07.784Z>
Sep 13 13:27:07 vagrant node_exporter[3182]: ts=2022-09-13T13:27:07.785Z>
Sep 13 13:27:07 vagrant node_exporter[3182]: ts=2022-09-13T13:27:07.786Z>
Sep 13 13:30:08 vagrant systemd[1]: Stopping Node Exporter...
Sep 13 13:30:08 vagrant systemd[1]: node_exporter.service: Succeeded.
Sep 13 13:30:08 vagrant systemd[1]: Stopped Node Exporter.
```

```bash
root@vagrant:/etc/systemd/system# ps -e | grep node_exporter
```

```bash
root@vagrant:/etc/systemd/system# systemctl restart node_exporter.service
```

```bash
root@vagrant:/etc/systemd/system# ps -e | grep node_exporter
3262 ? 00:00:00 node_exporter
```

```bash
root@vagrant:/etc/systemd/system# systemctl stop node_exporter.service
```

```bash
root@vagrant:/etc/systemd/system# ps -e | grep node_exporter
```

```bash
root@vagrant:/etc/systemd/system# systemctl start node_exporter.service
```

```bash
root@vagrant:/etc/systemd/system# ps -e | grep node_exporter
3342 ? 00:00:00 node_exporter
```

---------------------

#### После перезапуска машины процесc также запускается:

```sh
vagrant@vagrant:/etc/systemd/system$ exit
logout
Connection to 127.0.0.1 closed.
PS F:\vagrant> vagrant reload
PS F:\vagrant> vagrant ssh
Welcome to Ubuntu 20.04.4 LTS (GNU/Linux 5.4.0-110-generic x86_64)

* Documentation:  https://help.ubuntu.com
* Management:     https://landscape.canonical.com
* Support:        https://ubuntu.com/advantage

System information as of Tue 13 Sep 2022 01:58:56 PM UTC

System load:  1.72 Processes:             132
Usage of /:   13.5% of 30.63GB Users logged in:       0
Memory usage: 24% IPv4 address for eth0: 10.0.2.15
Swap usage:   0%

This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento
Last login: Tue Sep 13 12:39:16 2022 from 10.0.2.2
vagrant@vagrant:~$ ps -e | grep node_exporter
651 ? 00:00:00 node_exporter
```

2. Ознакомьтесь с опциями node_exporter и выводом `/metrics` по-умолчанию. Приведите несколько опций, которые вы бы
   выбрали для базового мониторинга хоста по CPU, памяти, диску и сети.

```
CPU:
node_cpu_seconds_total{cpu="0",mode="idle"} 2238.49
node_cpu_seconds_total{cpu="0",mode="system"} 16.72
node_cpu_seconds_total{cpu="0",mode="user"} 6.86
process_cpu_seconds_total

Memory:
node_memory_MemAvailable_bytes
node_memory_MemFree_bytes

Disk:
node_disk_io_time_seconds_total{device="sda"}
node_disk_read_bytes_total{device="sda"}
node_disk_read_time_seconds_total{device="sda"}
node_disk_write_time_seconds_total{device="sda"}

Network:
node_network_receive_errs_total{device="eth0"}
node_network_receive_bytes_total{device="eth0"}
node_network_transmit_bytes_total{device="eth0"}
node_network_transmit_errs_total{device="eth0"}
```

3. Установите в свою виртуальную машину [Netdata](https://github.com/netdata/netdata).
   Воспользуйтесь [готовыми пакетами](https://packagecloud.io/netdata/netdata/install) для
   установки (`sudo apt install -y netdata`).

   После успешной установки:
    * в конфигурационном файле `/etc/netdata/netdata.conf` в секции [web] замените значение с localhost
      на `bind to = 0.0.0.0`,
    * добавьте в Vagrantfile проброс порта Netdata на свой локальный компьютер и сделайте `vagrant reload`:

    ```bash
    config.vm.network "forwarded_port", guest: 19999, host: 19999
    ```

   После успешной перезагрузки в браузере *на своем ПК* (не в виртуальной машине) вы должны суметь зайти
   на `localhost:19999`. Ознакомьтесь с метриками, которые по умолчанию собираются Netdata и с комментариями, которые
   даны к этим метрикам.

#### **Netdata** установлена на виртуальной машине и открывается с хоста `http://localhost:19999/#menu_system_submenu_cpu;theme=slate;help=true`.

##### С метрикаим ознакомлен, удобно визуализированы различное множество метрик в виде онлайн-графиков загрузки.

4. Можно ли по выводу `dmesg` понять, осознает ли ОС, что загружена не на настоящем оборудовании, а на системе
   виртуализации?

##### Да, данная информация содержится в dmesg:

```bash
vagrant@vagrant:~$ dmesg -T   
[Tue Sep 13 13:57:35 2022] Hypervisor detected: KVM
[Tue Sep 13 13:57:35 2022] CPU MTRRs all blank - virtualized system.
[Tue Sep 13 13:57:35 2022] Booting paravirtualized kernel on KVM
[Tue Sep 13 13:57:39 2022] systemd[1]: Detected virtualization oracle.
```

5. Как настроен sysctl `fs.nr_open` на системе по-умолчанию? Определите, что означает этот параметр. Какой другой
   существующий лимит не позволит достичь такого числа (`ulimit --help`)?

```bash
vagrant@vagrant:~$ sysctl fs.nr_open
fs.nr_open = 1048576
```

`fs.nr_open` устанавливает системное ограничение на максимальное число открываемых файлов (аллоцируемых файловых
дескрипторов) команды `ulimit -Sn` и `ulimit -Hn` отображают **soft** (данный параметр можно увеличить системным вызовом setrlimit до
пределов, установленных в переменной hard), и **hard** значение вышеназванного ограничения, устанавливаемого на сессионном уровне.

```sh
vagrant@vagrant:~$ ulimit -Hn
1048576
vagrant@vagrant:~$ ulimit -Sn
1024
```
6. Запустите любой долгоживущий процесс (не `ls`, который отработает мгновенно, а, например, `sleep 1h`) в отдельном
   неймспейсе процессов; покажите, что ваш процесс работает под PID 1 через `nsenter`. Для простоты работайте в данном
   задании под root (`sudo -i`). Под обычным пользователем требуются дополнительные опции (`--map-root-user`) и т.д.

```sh
root@vagrant:~# ps -e |grep sleep
2020 pts/2    00:00:00 sleep
root@vagrant:~# nsenter --target 2020 --pid --mount
root@vagrant:/# ps
    PID TTY          TIME CMD
      2 pts/0    00:00:00 bash
     11 pts/0    00:00:00 ps
```
7. Найдите информацию о том, что такое `:(){ :|:& };:`. Запустите эту команду в своей виртуальной машине Vagrant с
   Ubuntu 20.04 (**это важно, поведение в других ОС не проверялось**). Некоторое время все будет "плохо", после чего (
   минуты) – ОС должна стабилизироваться. Вызов `dmesg` расскажет, какой механизм помог автоматической стабилизации.  
   Как настроен этот механизм по-умолчанию, и как изменить число процессов, которое можно создать в сессии?

#### Работу прервал Process Number Controller

`[ 9923.678400] cgroup: fork rejected by pids controller in /user.slice/user-1000.slice/session-6.scope`

Максимальное количество процессов для пользователя можно изменить командой
`ulimit -u <число>` или в файле `etc/security/limits.conf`.

Изменить максимальное количество PID можно посредством команд `sysctl -w kernel.pid_max=<число>, echo <число> > /proc/sys/kernel/pid_max` или задать переменную kernel.pid_max
в файле  `/etc/sysctl.conf`.


Ограничение на максимальное число процессов на уровне системы установлено в переменной DefaultTasksMax: `systemctl show
--property DefaultTasksMax`.

Изменить данную переменную можно в файле `/etc/systemd/system.conf`.
Переменная UserTasksMax в файле `/etc/systemd/logind.conf` позволяет установить ограничение по максимальному количеству
процессов на уровне пользователей.

----
