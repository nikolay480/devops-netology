# Домашнее задание к занятию "Операционные системы. Лекция 1"

### Цель задания

В результате выполнения этого задания вы:

1. Познакомитесь с инструментом strace, который помогает отслеживать системные вызовы процессов, и является необходимым
   для отладки и расследований в случае возникновения ошибок в работе программ.
2. Рассмотрите различные режимы работы скриптов, настраиваемые командой set. Один и тот же код в скриптах в разных
   режимах работы ведет себя по-разному.

<details>

### Чеклист готовности к домашнему заданию

1. Убедитесь, что у вас установлен инструмент `strace`, выполнив команду `strace -V` для проверки версии. В Ubuntu 20.04
   strace установлен, но в других дистрибутивах его может не быть "из коробки". Обратитесь к документации дистрибутива,
   как установить инструмент strace.
2. Убедитесь, что у вас установлен пакет `bpfcc-tools`
   , [сведения по установке](https://github.com/iovisor/bcc/blob/master/INSTALL.md)

### Инструменты/ дополнительные материалы, которые пригодятся для выполнения задания

1. Изучите документацию lsof - `man lsof` или та же информация, но в [сети](https://linux.die.net/man/8/lsof)
2. Документация по режимам работы bash находится в `help set` или
   в [сети](https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html)
</details>
------

## Задание

1. Какой системный вызов делает команда `cd`?

   В прошлом ДЗ мы выяснили, что `cd` не является самостоятельной программой, это `shell builtin`, поэтому
   запустить `strace` непосредственно на `cd` не получится. Тем не менее, вы можете запустить `strace`
   на `/bin/bash -c 'cd /tmp'`. В этом случае вы увидите полный список системных вызовов, которые делает сам `bash` при
   старте.

   Вам нужно найти тот единственный, который относится именно к `cd`. Обратите внимание, что `strace` выдаёт результат
   своей работы в поток stderr, а не в stdout.

    `chdir("/tmp")                          = 0`

2. Попробуйте использовать команду `file` на объекты разных типов в файловой системе. Например:
    ```bash
    vagrant@netology1:~$ file /dev/tty
    /dev/tty: character special (5/0)
    vagrant@netology1:~$ file /dev/sda
    /dev/sda: block special (8/0)
    vagrant@netology1:~$ file /bin/bash
    /bin/bash: ELF 64-bit LSB shared object, x86-64
    ```
   Используя `strace` выясните, где находится база данных `file`, на основании которой она делает свои догадки.

   ```bash
   /usr/share/misc/magic.mgc
   openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 4
     ```

3. Предположим, приложение пишет лог в текстовый файл. Этот файл оказался удален (deleted в lsof), однако возможности
   сигналом сказать приложению переоткрыть файлы или просто перезапустить приложение – нет. Так как приложение
   продолжает писать в удаленный файл, место на диске постепенно заканчивается. Основываясь на знаниях о перенаправлении
   потоков предложите способ обнуления открытого удаленного файла (чтобы освободить место на файловой системе).

   ```bash
   vagrant@vagrant:/proc$ sudo lsof | grep deleted
   bash 7829 vagrant 5w REG 253,0 10703 1323183 /home/vagrant/output.file (deleted)
   ping 8920 vagrant 1w REG 253,0 10703 1323183 /home/vagrant/output.file (deleted)
   ping 8920 vagrant 5w REG 253,0 10703 1323183 /home/vagrant/output.file (deleted)
   ```

   Далее записываем пустую строку в 5
`echo ""| tee /proc/1580/fd/5`
4. Занимают ли зомби-процессы какие-то ресурсы в ОС (CPU, RAM, IO)?

   Зомби-процессы не занимают какие-либо системные ресурсы, но сохраняют свой ID процесса в таблице.

5. В iovisor BCC есть утилита `opensnoop`:
    ```bash
    root@vagrant:~# dpkg -L bpfcc-tools | grep sbin/opensnoop
    /usr/sbin/opensnoop-bpfcc
    ```
   На какие файлы вы увидели вызовы группы `open` за первую секунду работы утилиты? Воспользуйтесь пакетом `bpfcc-tools`
   для Ubuntu 20.04. Дополнительные [сведения по установке](https://github.com/iovisor/bcc/blob/master/INSTALL.md).

   ```bash
   PID COMM FD ERR PATH
   643 irqbalance 6 0 /proc/interrupts
   643 irqbalance 6 0 /proc/stat
   643 irqbalance 6 0 /proc/irq/20/smp_affinity
   643 irqbalance 6 0 /proc/irq/0/smp_affinity
   643 irqbalance 6 0 /proc/irq/1/smp_affinity
   643 irqbalance 6 0 /proc/irq/8/smp_affinity
   643 irqbalance 6 0 /proc/irq/12/smp_affinity
   643 irqbalance 6 0 /proc/irq/14/smp_affinity
   643 irqbalance 6 0 /proc/irq/15/smp_affinity
   ```   

6. Какой системный вызов использует `uname -a`? Приведите цитату из man по этому системному вызову, где описывается
   альтернативное местоположение в `/proc`, где можно узнать версию ядра и релиз ОС.
   
   ```
   uname({sysname="Linux", nodename="vagrant", ...}) = 0
   uname({sysname="Linux", nodename="vagrant", ...}) = 0
   uname({sysname="Linux", nodename="vagrant", ...}) = 0
   
   "Part of the utsname information is also accessible via /proc/sys/ker‐
   nel/{ostype, hostname, osrelease, version, domainname}."
   ```
7. Чем отличается последовательность команд через `;` и через `&&` в bash? Например:
    ```bash
    root@netology1:~# test -d /tmp/some_dir; echo Hi
    Hi
    root@netology1:~# test -d /tmp/some_dir && echo Hi
    root@netology1:~#
    ```
   Есть ли смысл использовать в bash `&&`, если применить `set -e`?

   `; `- выполнение команд последовательно
   
   `&& `- команда после `&&` выполняется, только если команда до `&&` завершилась успешно (статус выхода 0)
   
   `set -e` - прерывает сессию при любом ненулевом значении исполняемых команд в конвейере кроме последней.
   использование `&&` вместе с `set -e`- вероятно не имеет смысла, так как при ошибке выполнение команд завершится.


9. Из каких опций состоит режим bash `set -euxo pipefail` и почему его хорошо было бы использовать в сценариях?
   ```
   -e Exit immediately if a command exits with a non-zero status.
   -u Treat unset variables as an error when substituting.
   -x Print commands and their arguments as they are executed.
   -o pipefail the return value of a pipeline is the status of the last command to exit with a non-zero status, or zero if
   no command exited with a non-zero status.
   ```

   Данный режим обеспечит прекращение выполнения скрипта в случае ошибок и выведет информацию, (лог ошибок).
 

10. Используя `-o stat` для `ps`, определите, какой наиболее часто встречающийся статус у процессов в системе. В `man ps`
    ознакомьтесь (`/PROCESS STATE CODES`) что значат дополнительные к основной заглавной буквы статуса процессов. Его
    можно не учитывать при расчете (считать S, Ss или Ssl равнозначными).

    ```bash
    vagrant@vagrant:~$ ps -o stat
    Ss - ожидание завершения события ( s - лидер сессии)
    R+ - работающий или в очереди на выполнение( + находится в группе приоритетных процессов)
    ```

      доп символы:
   
      `< `   high-priority (not nice to other users)
   
      `N `low-priority (nice to other users)
   
      `L` has pages locked into memory (for real-time and
   custom IO)
   
      `s` is a session leader
   
      `l` is multi-threaded (using CLONE_THREAD, like NPTL
   pthreads do)
   
      `+` is in the fo`reground process group
   
----