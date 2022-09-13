# devops-netology 

«2.4. Инструменты Git»


1.	git show aefea
commit aefead2207ef7e2aa5dc81a34aedf0cad4c32545

2.	git show 85024d3
tag: v0.12.23

3.	git checkout b8d720
git log --pretty=format:'%h %s' –graph
56cd7859e0, 9ea88f22fc

4.	git log --oneline v0.12.23..v0.12.24

b14b74c493 [Website] vmc provider links
3f235065b9 Update CHANGELOG.md
6ae64e247b registry: Fix panic when server is unreachable
5c619ca1ba website: Remove links to the getting started guide's old location
06275647e2 Update CHANGELOG.md
d5f9411f51 command: Fix bug when using terraform login on Windows
4b6d06cc5d Update CHANGELOG.md
dd01a35078 Update CHANGELOG.md
225466bc3e Cleanup after v0.12.23 release

5.	git log -S "func providerSource"

commit 8c928e83589d90a031f811fae52a81be7153e82f
Date:   Thu Apr 2 18:04:39 2020 -0700

6.	git grep -p "globalPluginDirs("
git log -L :globalPluginDirs:plugins.go
8364383c35 Push plugin discovery down into command package
66ebff90cd move some more plugin search path logic to command
41ab0aef7a Add missing OS_ARCH dir to global plugin paths
52dbf94834 keep .terraform.d/plugins for discovery
78b1220558 Remove config.go and update things using its aliases

7.	git log -S ‘func providerSource’
Author: Martin Atkins <mart@degeneration.co.uk>
Date:   Wed May 3 16:25:41 2017 -0700


### ### ### 
Домашнее задание к занятию "3.2. Работа в терминале, лекция 2"
1.	cd – внутренняя команда
vagrant@vagrant:~$ type cd
cd is a shell builtin
2.	grep <some_string> <some_file> -c  
3.	процесс /sbin/init
vagrant@vagrant:~$ ps aux
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root           1  0.0  1.1 167404 11532 ?        Ss   Sep02   0:06 /sbin/init
4.	ls -la /dir1 2>/dev/pts/1

5.	
vagrant@vagrant:~/test$ cat 1.txt
This is test message.
vagrant@vagrant:~/test$ cat < 1.txt > output.txt
vagrant@vagrant:~/test$ cat output.txt
This is test message.

6.	да
echo "Hello World!" > /dev/tty

7.	bash 5>&1 - создаем новый дескриптор 5 и перенаправляем его в STDOUT
echo netology > /proc/$$/fd/5 - перенаправляем результат команды в дескриптор 5
8.	Получится. Для этого нужно "поменять местами STDOUT и STDERR", создав, например, новый дескриптор  5 и использовать его как промежуточный
5>&1 1>&2 2>&5 . данное выражение выполнить после команды и перед pipe
9.	показывает переменные окружения для процесса, под которым выполняется текущая оболочка bash ($$). Аналогичный вывод у команды printenv
10.	/proc/[pid]/cmdline - Этот файл содержит полную командную строку запуска процесса, кроме тех процессов, что полностью ушли в своппинг, а также тех, что превратились в зомби. В этих двух случаях в файле ничего нет, то есть чтение этого файла вернет 0 символов. Аргументы командной строки в этом файле указаны как список строк, каждая из которых завешается нулевым символом, с добавочным нулевым байтом после последней строки.
/proc/[pid]/cmdline является символьной ссылкой, содержащей фактическое полное имя выполняемого файла. Символьная ссылка exe может использоваться обычным образом - при попытке открыть exe будет открыт исполняемый файл
11.	sse4_2
               vagrant@vagrant:~$ grep sse /proc/cpuinfo
fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx rdtscp lm constant_tsc rep_good nopl xtopology nonstop_tsc cpuid tsc_known_freq pni pclmulqdq ssse3 cx16 sse4_1 sse4_2 x2apic popcnt aes xsave avx hypervisor lahf_lm pti md_clear flush_l1d
12.	По умолчанию при запуске команды через SSH не выделяется TTY. Если же не указывать команды, то TTY будет выдаваться, так как предполагается, что будет запущен сеанс оболочки
Для принудительного использования необходимо указать ключ -t
vagrant@vagrant:~$ ssh -t localhost tty
vagrant@localhost's password:
/dev/pts/1
Connection to localhost closed.
13.	reptyr -s  3375
vagrant@vagrant:~$ sudo nano /proc/sys/kernel/yama/ptrace_scope
vagrant@vagrant:~$ reptyr -s  3375
[-] Timed out waiting for child stop.
Hangup
vagrant@vagrant:~$ screen -S 3375
[screen is terminating]
vagrant@vagrant:~$

14.	команда tee делает вывод одновременно и в файл, указанный в качестве параметра, и в stdout, 
в данном примере команда получает вывод из stdin, перенаправленный через pipe от stdout команды echo
и так как команда запущена от sudo , соотвественно имеет права на запись в файл

Домашнее задание к занятию "3.3. Операционные системы, лекция 1"
1. chdir("/tmp")                           = 0
2. /usr/share/misc/magic.mgc
   openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 4
3.
vagrant@vagrant:/proc$ sudo lsof | grep deleted
bash      7829                        vagrant    5w      REG              253,0    10703    1323183 /home/vagrant/output.file (deleted)
ping      8920                        vagrant    1w      REG              253,0    10703    1323183 /home/vagrant/output.file (deleted)
ping      8920                        vagrant    5w      REG              253,0    10703    1323183 /home/vagrant/output.file (deleted)

далее записываем пустую строку в 5
echo ""| tee /proc/1580/fd/5


4. Зомби-процессы не занимают какие-либо системные ресурсы, но сохраняют свой ID процесса в таблице.
5. 
PID    COMM               FD ERR PATH
643    irqbalance          6   0 /proc/interrupts
643    irqbalance          6   0 /proc/stat
643    irqbalance          6   0 /proc/irq/20/smp_affinity
643    irqbalance          6   0 /proc/irq/0/smp_affinity
643    irqbalance          6   0 /proc/irq/1/smp_affinity
643    irqbalance          6   0 /proc/irq/8/smp_affinity
643    irqbalance          6   0 /proc/irq/12/smp_affinity
643    irqbalance          6   0 /proc/irq/14/smp_affinity
643    irqbalance          6   0 /proc/irq/15/smp_affinity

6.
uname({sysname="Linux", nodename="vagrant", ...}) = 0
uname({sysname="Linux", nodename="vagrant", ...}) = 0
uname({sysname="Linux", nodename="vagrant", ...}) = 0

"Part of the utsname information is also accessible  via  /proc/sys/ker‐
       nel/{ostype, hostname, osrelease, version, domainname}."

7.
; - выполелнение команд последовательно
&& - команда после && выполняется только если команда до && завершилась успешно (статус выхода 0)
set -e - прерывает сессию при любом ненулевом значении исполняемых команд в конвейере кроме последней.
использование &&  вместе с set -e- вероятно не имеет смысла, так как при ошибке  выполнение команд завершится.

8. 
-e  Exit immediately if a command exits with a non-zero status.
-u  Treat unset variables as an error when substituting.
-x  Print commands and their arguments as they are executed.
-o pipefail     the return value of a pipeline is the status of the last command to exit with a non-zero status, or zero if no command exited with a non-zero status.
Данный режим обеспечит прекращение выполнения скрипта в случае ошибок и выведет информацию, (лог ошибок).

9. vagrant@vagrant:~$ ps -o stat
Ss - ожидание завершения события ( s - лидер сессии)
R+ - работающий или в очереди на выполнение( + находится в группе приоритетных процессов)

доп символы:
               <    high-priority (not nice to other users)
               N    low-priority (nice to other users)
               L    has pages locked into memory (for real-time and
                    custom IO)
               s    is a session leader
               l    is multi-threaded (using CLONE_THREAD, like NPTL
                    pthreads do)
               +    is in the foreground process group


Домашнее задание к занятию "3.4. Операционные системы, лекция 2"

1. 
Cоздан unit-файл для Node Exporter 
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
________----------_________

Node Exporter добавлен в автозагрузку:
root@vagrant:/etc/systemd/system$ sudo systemctl enable node_exporter
Created symlink /etc/systemd/system/multi-user.target.wants/node_exporter.service → /etc/systemd/system/node_exporter.service.
________----------_________

Процесс корректно останавливается и запускается, после перезагрузки процесс запускается:
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
root@vagrant:/etc/systemd/system# ps -e | grep node_exporter
   3182 ?        00:00:00 node_exporter
   
root@vagrant:/etc/systemd/system# systemctl stop node_exporter.service
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
root@vagrant:/etc/systemd/system# ps -e | grep node_exporter   

root@vagrant:/etc/systemd/system# systemctl restart node_exporter.service

root@vagrant:/etc/systemd/system# ps -e | grep node_exporter
   3262 ?        00:00:00 node_exporter

root@vagrant:/etc/systemd/system# systemctl stop node_exporter.service
root@vagrant:/etc/systemd/system# ps -e | grep node_exporter
root@vagrant:/etc/systemd/system# systemctl start node_exporter.service
root@vagrant:/etc/systemd/system# ps -e | grep node_exporter
   3342 ?        00:00:00 node_exporter
   
------------_________---------
после перезапуска машины также процес запускается
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

  System load:  1.72               Processes:             132
  Usage of /:   13.5% of 30.63GB   Users logged in:       0
  Memory usage: 24%                IPv4 address for eth0: 10.0.2.15
  Swap usage:   0%


This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento
Last login: Tue Sep 13 12:39:16 2022 from 10.0.2.2
vagrant@vagrant:~$ ps -e | grep node_exporter
    651 ?        00:00:00 node_exporter

 2. 
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

3.  Netdata установлена на виртуальной машине и открывается с хоста
http://localhost:19999/#menu_system_submenu_cpu;theme=slate;help=true
С метрикаим ознакомлен, удобно визуализированы различное множество метрик в виде онлайн-грфиков загрузки.

4. Да, данная информация содержится в dmesg
vagrant@vagrant:~$ dmesg -T
[Tue Sep 13 13:57:35 2022] Hypervisor detected: KVM
[Tue Sep 13 13:57:35 2022] CPU MTRRs all blank - virtualized system.
[Tue Sep 13 13:57:35 2022] Booting paravirtualized kernel on KVM
[Tue Sep 13 13:57:39 2022] systemd[1]: Detected virtualization oracle.

5. 
vagrant@vagrant:~$ sysctl fs.nr_open
fs.nr_open = 1048576

fs.nr_open устанавливает системное ограничение на максимальное число открываемых файлов (аллоцируемых файловых дескрипторов).
команды ulimit -Sn и ulimit -Hn отображают soft (данный параметр можно увеличить системным вызовом setrlimit до пределов установленных в переменной hard) и hard значение вышеназванного ограничения устанавливаемого на сессионном уровне.

vagrant@vagrant:~$ ulimit -Hn
1048576
vagrant@vagrant:~$ ulimit -Sn
1024

6. root@vagrant:/# ps -e |grep sleep
   1867 pts/0    00:00:00 sleep
   
   НЕПОНЯТНО КАК ДАЛЬШЕ ДЕЙСТВОВАТЬ, ПОДСКАЖИТЕ!
   
   
   
7. Работу прервал Process Number Controller
   [ 9923.678400] cgroup: fork rejected by pids controller in /user.slice/user-1000.slice/session-6.scope
   
   Максимальное количество процессов для пользователя можно изменить командой ulimit -u <число> или в файле cat etc/security/limits.conf
Изменить максимальное количество PID можно посредством команд sysctl -w kernel.pid_max=<число>,echo <число> > /proc/sys/kernel/pid_max или задать переменную kernel.pid_max в файле  /etc/sysctl.conf
Ограничение на максимальное число процессов на уровне системы установлено в переменной DefaultTasksMax: systemctl show --property DefaultTasksMax изменить данную переменную можно в файле /etc/systemd/system.conf
Переменная UserTasksMax в файле /etc/systemd/logind.conf позволяет установить ограничение по максимальному количеству процессов на уровне пользователей
   
   
