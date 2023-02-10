# Домашнее задание к занятию "4.2. Использование Python для решения типовых DevOps задач"

## Обязательная задача 1

Есть скрипт:

```python
#!/usr/bin/env python3
a = 1
b = '2'
c = a + b
```

### Вопросы:

| Вопрос  | Ответ                                                         |
| ------------- |---------------------------------------------------------------|
| Какое значение будет присвоено переменной `c`?  | TypeError: unsupported operand type(s) for +: 'int' and 'str' |
| Как получить для переменной `c` значение 12?  | c = str(a) + b                                                |
| Как получить для переменной `c` значение 3?  | c = a + int(b)                                                |

## Обязательная задача 2

Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие
файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в
его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. Как можно
доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?

```python
#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
        break
```

### Ваш скрипт:

```python
#!/bin/python3
import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()

for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(os.path.abspath(prepare_result))
```

### Вывод скрипта при запуске при тестировании:

```bash
nik@HOME-PC:~/netology/sysadm-homeworks$ git status
On branch master

No commits yet

Changes to be committed:
  (use "git rm --cached <file>..." to unstage)
        new file:   file1.txt
        new file:   file2.txt

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        modified:   file1.txt
        modified:   file2.txt

nik@HOME-PC:~$ ./pyt_scr.py
/home/nik/file1.txt
/home/nik/file2.txt
        
```

## Обязательная задача 3

1. Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел
   воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и
   будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.

### Ваш скрипт:

```python
#!/bin/python3
import os
import sys

path = sys.argv[1]

bash_command = ["cd " + path, "git status 2>&1"]
result_os = os.popen(' && '.join(bash_command)).read()

for result in result_os.split('\n'):
    if result.find("fatal: not a git repository (or any of the parent directories): .git") != -1:
        print(f'Директория {path} не является локальным репозиторием')
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(path + '/' + prepare_result)
```

### Вывод скрипта при запуске при тестировании:

```bash
nik@HOME-PC:~$ ./pyt_scr2.py ~/netology
Директория /home/nik/netology не является локальным репозиторием
nik@HOME-PC:~$ ./pyt_scr2.py ~/netology/sysadm-homeworks
/home/nik/netology/sysadm-homeworks/file1.txt
/home/nik/netology/sysadm-homeworks/file2.txt
```

## Обязательная задача 4

1. Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой
   балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. Проблема в том, что отдел,
   занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при
   этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не
   уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. Мы хотим написать скрипт, который
   опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>.
   Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если
   проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <
   старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: `drive.google.com`, `mail.google.com`
   , `google.com`.

### Ваш скрипт:

```python
#!/bin/python3
import socket
import time

servers = {'drive.google.com': '0.0.0.0', 'mail.google.com': '0.0.0.0', 'google.com': '0.0.0.0'}
t = 0

while (t < 5):

    for host, ip in servers.items():
        new_ip = socket.gethostbyname(host)
        if (ip != new_ip):
            print('[ERROR] {} IP mismatch: {} {}'.format(host, ip, new_ip))
            servers[host] = new_ip

    for host, ip in servers.items():
        print(f'{host} - {ip}')

    t += 1
    time.sleep(60)
```

### Вывод скрипта при запуске при тестировании:

За время тестирования ip серверов не изменился. Однако, исходя из того, что при первой проверке выдавалось сообщение об
ошибке, и то что значения в словаре перезаписываются, можно сделать вывод, что скрипт работоспособен.

```bash
nik@HOME-PC:~$ ./pyt_scr.py
[ERROR] drive.google.com IP mismatch: 0.0.0.0 142.250.186.174
[ERROR] mail.google.com IP mismatch: 0.0.0.0 216.58.212.133
[ERROR] google.com IP mismatch: 0.0.0.0 172.217.18.14
drive.google.com - 142.250.186.174
mail.google.com - 216.58.212.133
google.com - 172.217.18.14
drive.google.com - 142.250.186.174
mail.google.com - 216.58.212.133
google.com - 172.217.18.14
drive.google.com - 142.250.186.174
mail.google.com - 216.58.212.133
google.com - 172.217.18.14
drive.google.com - 142.250.186.174
mail.google.com - 216.58.212.133
google.com - 172.217.18.14
drive.google.com - 142.250.186.174
mail.google.com - 216.58.212.133
google.com - 172.217.18.14
```