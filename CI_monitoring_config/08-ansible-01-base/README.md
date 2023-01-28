# Домашнее задание к занятию "1. Введение в Ansible"

## Подготовка к выполнению
1. Установите ansible версии 2.10 или выше.
2. Создайте свой собственный публичный репозиторий на github с произвольным именем.
3. Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.

## Основная часть
1. Попробуйте запустить playbook на окружении из `test.yml`, зафиксируйте какое значение имеет факт `some_fact` для указанного хоста при выполнении playbook'a.

` "msg": 12`

```bash
nik@ubuntuVM:~/netology/ansible/lesson_08_01/playbook$ ansible-playbook -i inventory/test.yml site.yml

PLAY [Print os facts] **********************************************************

TASK [Gathering Facts] *********************************************************
ok: [localhost]

TASK [Print OS] ****************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}

TASK [Print fact] **************************************************************
ok: [localhost] => {
    "msg": 12
}

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0 
```

2. Найдите файл с переменными (group_vars) в котором задаётся найденное в первом пункте значение и поменяйте его на 'all default fact'.

[./playbook/group_vars/all/examp.yml](./playbook/group_vars/all/examp.yml):
```yaml
---
  some_fact: all default fact
```

3. Воспользуйтесь подготовленным (используется `docker`) или создайте собственное окружение для проведения дальнейших испытаний.

Установим коллекцию для работы с docker:
```bash
nik@ubuntuVM:~/netology/ansible/lesson_08_01/playbook$ ansible-galaxy collection install community.docker
Starting galaxy collection install process
Process install dependency map
Starting collection install process
Downloading https://galaxy.ansible.com/download/community-docker-3.4.0.tar.gz to /home/nik/.ansible/tmp/ansible-local-12028ho3agek6/tmpycxtt9je/community-docker-3.4.0-jycxattg
Installing 'community.docker:3.4.0' to '/home/nik/.ansible/collections/ansible_collections/community/docker'
community.docker:3.4.0 was installed successfully
```
Запустим в docker контейнеры c Ubuntu и Centos7:

```bash
docker run -d -it --name ubuntu pycontribs/ubuntu sleep 6000
docker run -d -it --name centos7 pycontribs/centos:7 sleep 6000
```
5. Проведите запуск playbook на окружении из `prod.yml`. Зафиксируйте полученные значения `some_fact` для каждого из `managed host`.
```bash
nik@ubuntuVM:~/netology/ansible/lesson_08_01/playbook$ ansible-playbook -i inventory/prod.yml site.yml

PLAY [Print os facts] ************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ******************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ****************************************************************************************************
ok: [centos7] => {
    "msg": "el"
}
ok: [ubuntu] => {
    "msg": "deb"
}

PLAY RECAP ***********************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0  
```
6. Добавьте факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились следующие значения: для `deb` - 'deb default fact', для `el` - 'el default fact'.

Внесем необходимые изменения в [./playbook/group_vars/deb/examp.yml](./playbook/group_vars/deb/examp.yml) и [./playbook/group_vars/el/examp.yml](./playbook/group_vars/el/examp.yml) .
8. Повторите запуск playbook на окружении `prod.yml`. Убедитесь, что выдаются корректные значения для всех хостов.
```bash
nik@ubuntuVM:~/netology/ansible/lesson_08_01/playbook$ ansible-playbook -i inventory/prod.yml site.yml

PLAY [Print os facts] ************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ******************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ****************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP ***********************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0 
```

8. При помощи `ansible-vault` зашифруйте факты в `group_vars/deb` и `group_vars/el` с паролем `netology`.
```bash
nik@ubuntuVM:~/netology/ansible/lesson_08_01/playbook$ ansible-vault encrypt group_vars/deb/examp.yml
New Vault password: 
Confirm New Vault password: 
Encryption successful
nik@ubuntuVM:~/netology/ansible/lesson_08_01/playbook$ ansible-vault encrypt group_vars/el/examp.yml
New Vault password: 
Confirm New Vault password: 
Encryption successful
```
10. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь в работоспособности.
```bash
nik@ubuntuVM:~/netology/ansible/lesson_08_01/playbook$ ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
Vault password: 

PLAY [Print os facts] *************************************************************************************************************

TASK [Gathering Facts] ************************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] *******************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] *****************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP ************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

11. Посмотрите при помощи `ansible-doc` список плагинов для подключения. Выберите подходящий для работы на `control node`.
```bash
nik@ubuntuVM:~/netology/ansible/lesson_08_01/playbook$ ansible-doc --type connection --list
community.docker.docker     Run tasks in docker containers                                                                   
community.docker.docker_api Run tasks in docker containers                                                                   
community.docker.nsenter    execute on host running controller container                                                     
local                       execute on controller                                                                            
paramiko_ssh                Run tasks via python ssh (paramiko)                                                              
psrp                        Run tasks over Microsoft PowerShell Remoting Protocol                                            
ssh                         connect via SSH client binary                                                                    
winrm                       Run tasks over Microsoft's WinRM  
```
Исходя из описания наиболее подходит плагин `local`. Этот плагин подключения позволяет `ansible` выполнять задачи на `‘контроллере’ Ansible`, а не на удаленном хосте.


12. В `prod.yml` добавьте новую группу хостов с именем  `local`, в ней разместите localhost с необходимым типом подключения.
```yaml
local:
    hosts:
      localhost:
        ansible_connection: local
```
13. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь что факты `some_fact` для каждого из хостов определены из верных `group_vars`.
```bash
nik@ubuntuVM:~/netology/ansible/lesson_08_01/playbook$ ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
Vault password: 

PLAY [Print os facts] ************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************
ok: [localhost]
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ******************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [localhost] => {
    "msg": "Ubuntu"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ****************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [localhost] => {
    "msg": "all default fact"
}

PLAY RECAP ***********************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0 
```
14. Заполните `README.md` ответами на вопросы. Сделайте `git push` в ветку `master`. В ответе отправьте ссылку на ваш открытый репозиторий с изменённым `playbook` и заполненным `README.md`.

## Необязательная часть

1. При помощи `ansible-vault` расшифруйте все зашифрованные файлы с переменными.

```bash
nik@ubuntuVM:~/netology/ansible/lesson_08_01/playbook$ ansible-vault decrypt group_vars/deb/examp.yml
Vault password: 
Decryption successful
nik@ubuntuVM:~/netology/ansible/lesson_08_01/playbook$ ansible-vault decrypt group_vars/el/examp.yml
Vault password: 
Decryption successful
nik@ubuntuVM:~/netology/ansible/lesson_08_01/playbook$ 
```

2. Зашифруйте отдельное значение `PaSSw0rd` для переменной `some_fact` паролем `netology`. Добавьте полученное значение в `group_vars/all/exmp.yml`.
```bash
nik@ubuntuVM:~/netology/ansible/lesson_08_01/playbook$ ansible-vault encrypt_string
New Vault password: 
Confirm New Vault password: 
Reading plaintext input from stdin. (ctrl-d to end input, twice if your content does not already have a newline)
PaSSw0rd      
!vault |
          $ANSIBLE_VAULT;1.1;AES256
          39353564393339383063396661326263616266356665343530383239636564373432663933363064
          3734663038613037343333313633626536613737316665320a653932643338623733326332633032
          36313930626362366161326261373236316536396539643132343661656632333264616433323935
          6338616238316633360a643933613539323462313335613335356433303636373739663332383965
          3965
Encryption successful
```
Заменим значение в файле [./playbook/group_vars/all/exmp.yml](./playbook/group_vars/all/exmp.yml)
```yaml
---
  some_fact: vault |
          $ANSIBLE_VAULT;1.1;AES256
          39353564393339383063396661326263616266356665343530383239636564373432663933363064
          3734663038613037343333313633626536613737316665320a653932643338623733326332633032
          36313930626362366161326261373236316536396539643132343661656632333264616433323935
          6338616238316633360a643933613539323462313335613335356433303636373739663332383965
          3965
```
3. Запустите `playbook`, убедитесь, что для нужных хостов применился новый `fact`.
```bash
ik@ubuntuVM:~/netology/ansible/lesson_08_01/playbook$ ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
Vault password: 

PLAY [Print os facts] ******************************************************************************************************************************************************************

TASK [Gathering Facts] *****************************************************************************************************************************************************************
ok: [localhost]
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ************************************************************************************************************************************************************************
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [localhost] => {
    "msg": "Ubuntu"
}

TASK [Print fact] **********************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [localhost] => {
    "msg": "vault | $ANSIBLE_VAULT;1.1;AES256 39353564393339383063396661326263616266356665343530383239636564373432663933363064 3734663038613037343333313633626536613737316665320a653932643338623733326332633032 36313930626362366161326261373236316536396539643132343661656632333264616433323935 6338616238316633360a643933613539323462313335613335356433303636373739663332383965 3965"
}

PLAY RECAP *****************************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```
4. Добавьте новую группу хостов `fedora`, самостоятельно придумайте для неё переменную. В качестве образа можно использовать [этот](https://hub.docker.com/r/pycontribs/fedora).
```yaml
fed:
    hosts:
      fedora:
        ansible_connection: docker
```
5. Напишите скрипт на bash: автоматизируйте поднятие необходимых контейнеров, запуск ansible-playbook и остановку контейнеров.

Создадим скрипт [script](./script.sh).

Сделаем файл исполняемым:

```bash
nik@ubuntuVM:~/netology/ansible/lesson_08_01$ chmod +x ./script.sh
```
Запустим:

```bash
nik@ubuntuVM:~/netology/ansible/lesson_08_01$ ./script.sh
Running containers in docker...
54f269ed54e63ef9d58a2136b88025edd9c47b39e53f415ddd77a7d317063b96
1fd0981eaf4e0a9957c27ec6e0a6b89e98954df300f7fd4082ccbab59f90e329
c8af1352b7d40c10e49b28acaf3803c0e8ff4c5fcd2fc49bac5947a641315869
Running ansible-playbook...
Vault password: 

PLAY [Print os facts] ****************************************************************************************************************************************************

TASK [Gathering Facts] ***************************************************************************************************************************************************
ok: [fedora]
ok: [localhost]
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] **********************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [localhost] => {
    "msg": "Ubuntu"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [fedora] => {
    "msg": "Fedora"
}

TASK [Print fact] ********************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [localhost] => {
    "msg": "vault | $ANSIBLE_VAULT;1.1;AES256 39353564393339383063396661326263616266356665343530383239636564373432663933363064 3734663038613037343333313633626536613737316665320a653932643338623733326332633032 36313930626362366161326261373236316536396539643132343661656632333264616433323935 6338616238316633360a643933613539323462313335613335356433303636373739663332383965 3965"
}
ok: [fedora] => {
    "msg": "vault | $ANSIBLE_VAULT;1.1;AES256 39353564393339383063396661326263616266356665343530383239636564373432663933363064 3734663038613037343333313633626536613737316665320a653932643338623733326332633032 36313930626362366161326261373236316536396539643132343661656632333264616433323935 6338616238316633360a643933613539323462313335613335356433303636373739663332383965 3965"
}

PLAY RECAP ***************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
fedora                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

Stopping containers ...
fedora
ubuntu
centos7
```

---