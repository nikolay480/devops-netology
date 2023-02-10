# Домашнее задание к занятию "4. Работа с roles"

## Подготовка к выполнению

<details>
1. (Необязательно) Познакомьтесь с [lighthouse](https://youtu.be/ymlrNlaHzIY?t=929)
2. Создайте два пустых публичных репозитория в любом своём проекте: vector-role и lighthouse-role.
3. Добавьте публичную часть своего ключа к своему профилю в github.
</details>

## Основная часть

Наша основная цель - разбить наш playbook на отдельные roles. Задача: сделать roles для clickhouse, vector и lighthouse и написать playbook для использования этих ролей. Ожидаемый результат: существуют три ваших репозитория: два с roles и один с playbook.

1. Создать в старой версии playbook файл `requirements.yml` и заполнить его следующим содержимым:

   ```yaml
   ---
     - src: git@github.com:AlexeySetevoi/ansible-clickhouse.git
       scm: git
       version: "1.11.0"
       name: clickhouse 
   ```

2. При помощи `ansible-galaxy` скачать себе эту роль.
3. Создать новый каталог с ролью при помощи `ansible-galaxy role init vector-role`.
4. На основе tasks из старого playbook заполните новую role. Разнесите переменные между `vars` и `default`. 
5. Перенести нужные шаблоны конфигов в `templates`.
6. Описать в `README.md` обе роли и их параметры.
7. Повторите шаги 3-6 для lighthouse. Помните, что одна роль должна настраивать один продукт.
8. Выложите все roles в репозитории. Проставьте тэги, используя семантическую нумерацию Добавьте roles в `requirements.yml` в playbook.
9. Переработайте playbook на использование roles. Не забудьте про зависимости lighthouse и возможности совмещения `roles` с `tasks`.
10. Выложите playbook в репозиторий.
11. В ответ приведите ссылки на оба репозитория с roles и одну ссылку на репозиторий с playbook.

## Ответ
* [vector-role](https://github.com/nikolay480/vector-role/)

* [lighthouse-role](https://github.com/nikolay480/lighthouse-role)

* [playbook](./playbook)

### Установка ролей:
```bash
nik@ubuntuVM:~/netology/ansible/lesson_08_04/playbook$ ansible-galaxy install -r requirements.yml -p roles --force
Starting galaxy role install process
- extracting clickhouse to /home/nik/netology/ansible/lesson_08_04/playbook/roles/clickhouse
- clickhouse (1.11.0) was installed successfully
- extracting vectore-role to /home/nik/netology/ansible/lesson_08_04/playbook/roles/vectore-role
- vectore-role (0.1.1) was installed successfully
- extracting lighthouse-role to /home/nik/netology/ansible/lesson_08_04/playbook/roles/lighthouse-role
- lighthouse-role (0.1.1) was installed successfully
```

### Результат выполнения плейбука:

<details>

   ```bash
nik@ubuntuVM:~/netology/ansible/lesson_08_04/playbook$ ansible-playbook -i inventory/prod.yml site.yml

PLAY [Install Clickhouse] ***************************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************************
ok: [clickhouse-1]

TASK [clickhouse : Include OS Family Specific Variables] ********************************************************************************************************
ok: [clickhouse-1]

TASK [clickhouse : include_tasks] *******************************************************************************************************************************
included: /home/nik/netology/ansible/lesson_08_04/playbook/roles/clickhouse/tasks/precheck.yml for clickhouse-1

TASK [clickhouse : Requirements check | Checking sse4_2 support] ************************************************************************************************
ok: [clickhouse-1]

TASK [clickhouse : Requirements check | Not supported distribution && release] **********************************************************************************
skipping: [clickhouse-1]

TASK [clickhouse : include_tasks] *******************************************************************************************************************************
included: /home/nik/netology/ansible/lesson_08_04/playbook/roles/clickhouse/tasks/params.yml for clickhouse-1

TASK [clickhouse : Set clickhouse_service_enable] ***************************************************************************************************************
ok: [clickhouse-1]

TASK [clickhouse : Set clickhouse_service_ensure] ***************************************************************************************************************
ok: [clickhouse-1]

TASK [clickhouse : include_tasks] *******************************************************************************************************************************
included: /home/nik/netology/ansible/lesson_08_04/playbook/roles/clickhouse/tasks/install/yum.yml for clickhouse-1

TASK [clickhouse : Install by YUM | Ensure clickhouse repo GPG key imported] ************************************************************************************
ok: [clickhouse-1]

TASK [clickhouse : Install by YUM | Ensure clickhouse repo installed] *******************************************************************************************
ok: [clickhouse-1]

TASK [clickhouse : Install by YUM | Ensure clickhouse package installed (latest)] *******************************************************************************
ok: [clickhouse-1]

TASK [clickhouse : Install by YUM | Ensure clickhouse package installed (version latest)] ***********************************************************************
skipping: [clickhouse-1]

TASK [clickhouse : include_tasks] *******************************************************************************************************************************
included: /home/nik/netology/ansible/lesson_08_04/playbook/roles/clickhouse/tasks/configure/sys.yml for clickhouse-1

TASK [clickhouse : Check clickhouse config, data and logs] ******************************************************************************************************
ok: [clickhouse-1] => (item=/var/log/clickhouse-server)
ok: [clickhouse-1] => (item=/etc/clickhouse-server)
ok: [clickhouse-1] => (item=/var/lib/clickhouse/tmp/)
ok: [clickhouse-1] => (item=/var/lib/clickhouse/)

TASK [clickhouse : Config | Create config.d folder] *************************************************************************************************************
ok: [clickhouse-1]

TASK [clickhouse : Config | Create users.d folder] **************************************************************************************************************
ok: [clickhouse-1]

TASK [clickhouse : Config | Generate system config] *************************************************************************************************************
ok: [clickhouse-1]

TASK [clickhouse : Config | Generate users config] **************************************************************************************************************
ok: [clickhouse-1]

TASK [clickhouse : Config | Generate remote_servers config] *****************************************************************************************************
skipping: [clickhouse-1]

TASK [clickhouse : Config | Generate macros config] *************************************************************************************************************
skipping: [clickhouse-1]

TASK [clickhouse : Config | Generate zookeeper servers config] **************************************************************************************************
skipping: [clickhouse-1]

TASK [clickhouse : Config | Fix interserver_http_port and intersever_https_port collision] **********************************************************************
skipping: [clickhouse-1]

TASK [clickhouse : Notify Handlers Now] *************************************************************************************************************************

TASK [clickhouse : include_tasks] *******************************************************************************************************************************
included: /home/nik/netology/ansible/lesson_08_04/playbook/roles/clickhouse/tasks/service.yml for clickhouse-1

TASK [clickhouse : Ensure clickhouse-server.service is enabled: True and state: started] ************************************************************************
ok: [clickhouse-1]

TASK [clickhouse : Wait for Clickhouse Server to Become Ready] **************************************************************************************************
ok: [clickhouse-1]

TASK [clickhouse : include_tasks] *******************************************************************************************************************************
included: /home/nik/netology/ansible/lesson_08_04/playbook/roles/clickhouse/tasks/configure/db.yml for clickhouse-1

TASK [clickhouse : Set ClickHose Connection String] *************************************************************************************************************
ok: [clickhouse-1]

TASK [clickhouse : Gather list of existing databases] ***********************************************************************************************************
ok: [clickhouse-1]

TASK [clickhouse : Config | Delete database config] *************************************************************************************************************

TASK [clickhouse : Config | Create database config] *************************************************************************************************************

TASK [clickhouse : include_tasks] *******************************************************************************************************************************
included: /home/nik/netology/ansible/lesson_08_04/playbook/roles/clickhouse/tasks/configure/dict.yml for clickhouse-1

TASK [clickhouse : Config | Generate dictionary config] *********************************************************************************************************
skipping: [clickhouse-1]

TASK [clickhouse : include_tasks] *******************************************************************************************************************************
skipping: [clickhouse-1]

PLAY [Install Vector] *******************************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************************
ok: [vector-1]

TASK [vector-role : Creates directory tmp/vector/] *************************************************************************************************************
ok: [vector-1]

TASK [vectore-role : Get vector] ********************************************************************************************************************************
ok: [vector-1]

TASK [vector-role : install vector] ****************************************************************************************************************************
ok: [vector-1]

TASK [vector-role : Copy config] *******************************************************************************************************************************
ok: [vector-1]

TASK [vector-role : Restart vector service] ********************************************************************************************************************
changed: [vector-1]

PLAY [Install lighthouse] ***************************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************************
ok: [lighthouse-1]

TASK [INSTALL NGINX | install repo epel-release] ****************************************************************************************************************
changed: [lighthouse-1]

TASK [INSTALL NGINX | nginx] ************************************************************************************************************************************
changed: [lighthouse-1]

TASK [INSTALL NGINX | config] ***********************************************************************************************************************************
changed: [lighthouse-1]

RUNNING HANDLER [start_nginx] ***********************************************************************************************************************************
changed: [lighthouse-1]

RUNNING HANDLER [restart_nginx] *********************************************************************************************************************************
changed: [lighthouse-1]

TASK [lighthouse-role : LIGHTHOUSE | git] ***********************************************************************************************************************
ok: [lighthouse-1]

TASK [lighthouse-role : LIGHTHOUSE |  Download from git] ********************************************************************************************************
ok: [lighthouse-1]

TASK [lighthouse-role : LIGHTHOUSE | config] ********************************************************************************************************************
changed: [lighthouse-1]

RUNNING HANDLER [restart_nginx] *********************************************************************************************************************************
changed: [lighthouse-1]

PLAY RECAP ******************************************************************************************************************************************************
clickhouse-1               : ok=24   changed=0    unreachable=0    failed=0    skipped=10   rescued=0    ignored=0   
lighthouse-1               : ok=10   changed=7    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
vector-1                   : ok=6    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
   ```
</details>
---