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

5.	root@vagrant:/home#  cat ./script1.sh > out_file1.txt

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

