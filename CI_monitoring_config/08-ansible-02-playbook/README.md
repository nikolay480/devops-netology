# Домашнее задание к занятию "2. Работа с Playbook"

## Подготовка к выполнению

1. (Необязательно) Изучите, что такое [clickhouse](https://www.youtube.com/watch?v=fjTNS2zkeBs)
   и [vector](https://www.youtube.com/watch?v=CgEhyffisLY)
2. Создайте свой собственный (или используйте старый) публичный репозиторий на github с произвольным именем.
3. Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.
4. Подготовьте хосты в соответствии с группами из предподготовленного playbook.

## Основная часть

1. Приготовьте свой собственный inventory файл `prod.yml`.

```
---
clickhouse:
  hosts:
    centos7:
      ansible_host: 158.160.56.198

vector:
  hosts:
    centos7:
      ansible_host: 158.160.56.198
```

2. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает [vector](https://vector.dev).
   Добавим еще один play, в котором будут задачи: создание директории (Creates directory) , скачивание rpm пакета ( Get
   vector), установка (install vector), копирование файла конфигурации на manage node(Copy config) и перезапуск демона.

```yaml

- name: Install Vector
  hosts: vector
  tags: vector
  tasks:
    - name: Creates directory tmp/vector/
      become: true
      file:
        path: /tmp/vector/
        state: directory
    - name: Get vector
      become: true
      ansible.builtin.get_url:
        url: "https://packages.timber.io/vector/0.27.0/vector-0.27.0-1.{{ arch }}.rpm"
        dest: "/tmp/vector/vector-0.27.0-1.{{ arch }}.rpm"
    - name: install vector
      become: true
      become_user: root
      ansible.builtin.yum:
        name: "/tmp/vector/vector-0.27.0-1.{{ arch }}.rpm"
    - name: Copy config
      become: true
      ansible.builtin.copy:
        src: ./vector_config/vector.yaml
        dest: /etc/vector/vector.yaml
        owner: root
        group: root
        mode: '777'
    - name: Restart vector service
      become: true
      ansible.builtin.systemd:
        name: vector
        state: restarted
        daemon_reload: true
```

3. При создании tasks рекомендую использовать модули: `get_url`, `template`, `unarchive`, `file`.
4. `Tasks` должны: скачать нужной версии дистрибутив, выполнить распаковку в выбранную директорию, установить `vector`.
5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.
```bash
nik@ubuntuVM:~/netology/ansible/lesson_08_02/playbook$ ansible-lint site.yml
[201] Trailing whitespace
site1.yml:52
      daemon_reload: true 

[201] Trailing whitespace
site1.yml:58
        state: directory      

[201] Trailing whitespace
site1.yml:59
    - name: Get vector 

[201] Trailing whitespace
site1.yml:64
    - name: install vector 

[201] Trailing whitespace
site1.yml:68
        name: "/tmp/vector/vector-0.27.0-1.{{ arch }}.rpm"    

[301] Commands should not change things if nothing needs doing
site1.yml:77
Task/Handler: change configuration file
```
Ошибки устранены, в основном это лишние пробелы в конце строки `(Trailing whitespace)`
6. Попробуйте запустить `playbook` на этом окружении с флагом `--check`.
```bash
nik@ubuntuVM:~/netology/ansible/lesson_08_02/playbook$ ansible-playbook -i inventory/prod.yml site1.yml --user centos --check

PLAY [Install Clickhouse] ******************************************************************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************************************************
ok: [centos7]

TASK [Get clickhouse distrib] **************************************************************************************************************************************************
ok: [centos7] => (item=clickhouse-client)
ok: [centos7] => (item=clickhouse-server)
failed: [centos7] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 1000, "group": "centos", "item": "clickhouse-common-static", "mode": "0664", "msg": "Request failed", "owner": "centos", "response": "HTTP Error 404: Not Found", "secontext": "unconfined_u:object_r:user_home_t:s0", "size": 246310036, "state": "file", "status_code": 404, "uid": 1000, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] **************************************************************************************************************************************************
ok: [centos7]

TASK [Install clickhouse packages] *********************************************************************************************************************************************
ok: [centos7]

TASK [Flush handler] ***********************************************************************************************************************************************************

TASK [Create database] *********************************************************************************************************************************************************
skipping: [centos7]

TASK [Create table] ************************************************************************************************************************************************************
skipping: [centos7]

PLAY [Install Vector] **********************************************************************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************************************************
ok: [centos7]

TASK [Creates directory tmp/vector/] *******************************************************************************************************************************************
ok: [centos7]

TASK [Get vector] **************************************************************************************************************************************************************
ok: [centos7]

TASK [install vector] **********************************************************************************************************************************************************
ok: [centos7]

TASK [Copy config] *************************************************************************************************************************************************************
ok: [centos7]

TASK [Restart vector service] **************************************************************************************************************************************************
changed: [centos7]

PLAY RECAP *********************************************************************************************************************************************************************
centos7                    : ok=9    changed=1    unreachable=0    failed=0    skipped=2    rescued=1    ignored=0   
```

7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.
```bash
nik@ubuntuVM:~/netology/ansible/lesson_08_02/playbook$ ansible-playbook -i inventory/prod.yml site1.yml --user centos --diff

PLAY [Install Clickhouse] ******************************************************************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************************************************
ok: [centos7]

TASK [Get clickhouse distrib] **************************************************************************************************************************************************
ok: [centos7] => (item=clickhouse-client)
ok: [centos7] => (item=clickhouse-server)
failed: [centos7] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 1000, "group": "centos", "item": "clickhouse-common-static", "mode": "0664", "msg": "Request failed", "owner": "centos", "response": "HTTP Error 404: Not Found", "secontext": "unconfined_u:object_r:user_home_t:s0", "size": 246310036, "state": "file", "status_code": 404, "uid": 1000, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] **************************************************************************************************************************************************
ok: [centos7]

TASK [Install clickhouse packages] *********************************************************************************************************************************************
ok: [centos7]

TASK [Flush handler] ***********************************************************************************************************************************************************

TASK [Create database] *********************************************************************************************************************************************************
ok: [centos7]

TASK [Create table] ************************************************************************************************************************************************************
changed: [centos7]

PLAY [Install Vector] **********************************************************************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************************************************
ok: [centos7]

TASK [Creates directory tmp/vector/] *******************************************************************************************************************************************
ok: [centos7]

TASK [Get vector] **************************************************************************************************************************************************************
ok: [centos7]

TASK [install vector] **********************************************************************************************************************************************************
ok: [centos7]

TASK [Copy config] *************************************************************************************************************************************************************
ok: [centos7]

TASK [Restart vector service] **************************************************************************************************************************************************
changed: [centos7]

PLAY RECAP *********************************************************************************************************************************************************************
centos7                    : ok=11   changed=2    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0 
```
8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.

Повторный запуск дает полностью аналогичный вывод, следовательно, можно говорить об` идемпотентности` playbook.

9. Подготовьте README.md файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть
   параметры и теги: [readme.md](./playbook/readme.md)

10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-02-playbook` на фиксирующий коммит, в ответ
    предоставьте ссылку на него: [playbook](./playbook)


---