## Домашнее задание к занятию "5.1. Введение в виртуализацию. Типы и функции гипервизоров. Обзор рынка вендоров и областей применения."

### Задача 1

_Опишите кратко, как вы поняли: в чем основное отличие полной (аппаратной) виртуализации, паравиртуализации и
виртуализации на основе ОС._

### Ответ

**Полная виртуализация** - это когда система управления виртуальными машинами полностью и на 100% изображает компьютер,
со всеми физическими устройствами, обеспечивая тотальную изоляцию гостевой ОС.

**Паравиртуализация** - программное обеспечение, использующее операционную систему для разделения ресурсов между
виртуальными машинами.

**Виртуализация на уровне ОС** реализуется без отдельного слоя гипервизора, виртуализируется пользовательское окружение
ОС.

*`Дополнительный вопрос`**: В чём разница при работе с ядром гостевой ОС для полной и паравиртуализации?

При полной виртуализации виртуальные машины позволяют выполнять инструкции при запуске неизмененной операционной системы
полностью изолированным способом.

В отличие от полной виртуализации, паравиртуализация не реализует полную изоляцию; вместо этого в подходе реализована
частичная изоляция. Гипервизор в данном случае изменяет ядро ОС

Основное отличие паравиртуализации от остальных типов виртуализации - необходимость модификации ядра гостевой ОС.

### Задача 2

Выберите один из вариантов использования организации физических серверов, в зависимости от условий использования.

Организация серверов:

физические сервера, паравиртуализация, виртуализация уровня ОС.

Условия использования:

Высоконагруженная база данных, чувствительная к отказу.
Различные web-приложения.
Windows системы для использования бухгалтерским отделом.
Системы, выполняющие высокопроизводительные расчеты на GPU.
Опишите, почему вы выбрали к каждому целевому использованию такую организацию.

### Ответ

**Высоконагруженная база данных, чувствительная к отказу** - физические сервера, поскольку применение виртуализации в
данном случае уменьшит производительность и ухудшит надёжность. Кластер можно собрать при помощи самой СУБД, без
использования средств виртуализации.

**Различные web-приложения** - виртуализация уровня ОС, т.к. используется пользовательское окружение

**Windows системы для использования бухгалтерским отделом** - паравиртуализация, например Hyper-V. Среди преимуществ
облегченное создание бэкапов и миграции.

**Системы, выполняющие высокопроизводительные расчеты на GPU** - лучше размещать на аппаратной виртуализации для того
чтобы задействовать максимум ресурсов.

### Задача 3

Выберите подходящую систему управления виртуализацией для предложенного сценария. Детально опишите ваш выбор.

Сценарии:

1) 100 виртуальных машин на базе Linux и Windows, общие задачи, нет особых требований. Преимущественно Windows based
   инфраструктура, требуется реализация программных балансировщиков нагрузки, репликации данных и автоматизированного
   механизма создания резервных копий.
2) Требуется наиболее производительное бесплатное open source решение для виртуализации небольшой (20-30 серверов)
   инфраструктуры на базе Linux и Windows виртуальных машин.
3) Необходимо бесплатное, максимально совместимое и производительное решение для виртуализации Windows инфраструктуры.
4) Необходимо рабочее окружение для тестирования программного продукта на нескольких дистрибутивах Linux.

### Ответ

1) Коммерческие VMwareESXI или Vsphere. Так как преимущественно Windows - инфраструктура, можно использовать Hyper-V.
2) Могут подойти Xen, KVM. Xen - кроссплатформенный гипервизор.
3) Microsoft Hyper-V Server имеющий наибольшую совместимость с Windows системами. Как альтернатива - Xen.
4) Наибольшую скорость развёртывания в данном случае могут обеспечить решения виртуализации уровне ОС - Docker, Podman.

### Задача 4

Опишите возможные проблемы и недостатки гетерогенной среды виртуализации (использования нескольких систем управления
виртуализацией одновременно) и что необходимо сделать для минимизации этих рисков и проблем. Если бы у вас был выбор, то
создавали бы вы гетерогенную среду или нет? Мотивируйте ваш ответ примерами.

### Ответ

Гетерогенные виртуальные среды могут быть неэффективны и сложны в управлении.
Требуется целый набор специалистов различного профиля, данный способ виртуализации инфраструктуры является дорогостоящим
и неэффективным в долгосрочной перспективе, поскольку, по мере развития технологий, компании стремятся обеспечить
легкость в управлении, совместимость различных систем и масштабируемость инфраструктуры. Усложняются операции по
переносу виртуальных машин между различными средами и масштабированию.

Необходимость создания гетерогенной среды может быть продиктована, например, решением задач распределения аппаратных
ресурсов посредством полной виртуализации и облегчения задач размещения и развёртывания программного обеспечения
посредством виртуализационных решений на уровне ОС;

___

## Домашнее задание к занятию "2. Применение принципов IaaC в работе с виртуальными машинами"

### Задача 1

* Опишите своими словами основные преимущества применения на практике IaaC паттернов.
* Какой из принципов IaaC является основополагающим?

### Ответ

* **CI/CD (+СD)** — набор методов и практик, отвечающий требованиям современной ПО-разработки. Принципы непрерывной
  интеграции
  и доставки помогают внедрять решения быстро, оперативно согласовывать их и доводить до релиза, не рискуя при этом
  качеством продукта.CI/CD не стоит считать панацеей для каждой ситуации — для внедрения этой методологии нужно знать
  бизнес-приоритеты, иметь четкий план действий, согласованные технологии и, конечно же, команду опытных
  DevOps-специалистов.

* Основным принципом IaaC является **идемпотентность** - это свойство объекта или операции, при повторном выполнении
  которой
  мы получаем результат идентичный предыдущему и всем последующим выполнениям

### Задача 2

* Чем Ansible выгодно отличается от других систем управление конфигурациями?
* Какой, на ваш взгляд, метод работы систем конфигурации более надёжный push или pull?

Преимущества Ansible по сравнению с другими аналогичными решениями:

1. на управляемые узлы не нужно устанавливать никакого дополнительного ПО, всё работает через SSH (в случае
   необходимости дополнительные модули можно взять из официального репозитория);
2. код программы, написанный на Python, очень прост; при необходимости написание дополнительных модулей не составляет
   особого труда;
3. язык, на котором пишутся сценарии, также предельно прост;
4. низкий порог вхождения: обучиться работе с Ansible можно за очень короткое время;
5. документация к продукту написана очень подробно и вместе с тем — просто и понятно; она регулярно обновляется;

* метод push, потому что не требует установки ни демонов, ни агентов, в случае с pull методом такие агенты нужны, что
  потенциально может быть еще одной точкой сбоя.

### Задача 3

Установить на личный компьютер:

* VirtualBox
* Vagrant
* Ansible

Приложить вывод команд установленных версий каждой из программ, оформленный в markdown.

```bash
nik@ubuntuVM:~$ vboxmanage --version
6.1.38_Ubuntur153438
nik@ubuntuVM:~$ vagrant --version
Vagrant 2.2.6
nik@ubuntuVM:~$ ansible --version
ansible 2.9.6
  config file = /etc/ansible/ansible.cfg
  configured module search path = ['/home/nik/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3/dist-packages/ansible
  executable location = /usr/bin/ansible
  python version = 3.8.10 (default, Jun 22 2022, 20:18:18) [GCC 9.4.0]
```

___

## Домашнее задание к занятию "3. Введение. Экосистема. Архитектура. Жизненный цикл Docker контейнера"

### Задача 1

<details>
Сценарий выполения задачи:

* создайте свой репозиторий на https://hub.docker.com;
* выберете любой образ, который содержит веб-сервер Nginx;
* создайте свой fork образа;
* реализуйте функциональность: запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже:

```html

<html>
<head>
    Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
```

Опубликуйте созданный форк в своем репозитории и предоставьте ответ в виде ссылки
на https://hub.docker.com/username_repo
</details>

### Ответ

Ссылка на репозиторий:
`https://hub.docker.com/repository/docker/nikolay480/`

```bash
nik@ubuntuVM:~/netology/3.1.Docker$ cat Dockerfile
FROM nginx:alpine
COPY ./index.html /usr/share/nginx/html/index.html
```

```bash
nik@ubuntuVM:~/netology/3.1.Docker$ docker build -t nikolay480/webpage:v.1.1 .
nik@ubuntuVM:~/netology/3.1.Docker$ docker run -d -p 80:80 nikolay480/webpage:v.1.1
f111079122dd13062e8982717f0fe0d0964e5a638889a21fa142d9168b6c3d37
nik@ubuntuVM:~/netology/3.1.Docker$ docker ps
CONTAINER ID   IMAGE                      COMMAND                  CREATED          STATUS          PORTS                               NAMES
f111079122dd   nikolay480/webpage:v.1.1   "/docker-entrypoint.…"   19 seconds ago   Up 18 seconds   0.0.0.0:80->80/tcp, :::80->80/tcp   cool_noyce
```

```bash 
nik@ubuntuVM:~/netology/3.1.Docker$ docker push nikolay480/webpage:v.1.1
The push refers to repository [docker.io/nikolay480/webpage]
bb4444ee2a15: Pushed 
bd502c2dee4c: Pushed 
9365b1fffb04: Pushed 
6636f46e559d: Pushed 
fcf860bf48b4: Pushed 
07099189e7ec: Pushed 
e5e13b0c77cb: Pushed 
v.1.1: digest: sha256:387a71095d812baed31124340228e768da36a9387bc7c2a372bc4294a87006c3 size: 1775
```

### Задача 2

<details>

Посмотрите на сценарий ниже и ответьте на вопрос: "Подходит ли в этом сценарии использование Docker контейнеров или
лучше подойдет виртуальная машина, физическая машина? Может быть возможны разные варианты?"

Детально опишите и обоснуйте свой выбор.
</details>

### Ответ

* Высоконагруженное монолитное java веб-приложение - предпочтительнее VM, так как приложение монолитное и не разбито на
  сервисы/микросервисы
* **Nodejs веб-приложение** - использование docker-контейнеризации позволит снизить затраты на развертывание приложения,
  установку зависимостей.
* Мобильное приложение c версиями для Android и iOS - виртуальная машина, для упрощения тестирования
* **Шина данных на базе Apache Kafka** - возможно развернуть в docker.
* **Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash
  и две ноды kibana;** - для Elasticsearch в связи с немаленькими системными требованиями потребуется VM. Однако
  возможно также развернуть в контейнерах, используя Docker Compose.
* **Мониторинг-стек на базе Prometheus и Grafana** - возможно использование docker или VM, так как системные требования
  меньше, чем у ELK, а также для упрощения развертывания и масштабирования.
* **MongoDB, как основное хранилище данных для java-приложения** - можно использовать все три варианта, при этом для
  Docker потребуется смонтировать внешний том для хранения данных. Использование физического сервера будет надежнее VM.
* **Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry** - возможно развертывание как
  через docker, так и на виртуальной или физической машине.

### Задача 3

<details>

* Запустите первый контейнер из образа centos c любым тэгом в фоновом режиме, подключив папку /data из текущей рабочей
  директории на хостовой машине в /data контейнера;
* Запустите второй контейнер из образа debian в фоновом режиме, подключив папку /data из текущей рабочей директории на
  хостовой машине в /data контейнера;
* Подключитесь к первому контейнеру с помощью docker exec и создайте текстовый файл любого содержания в /data;
* Добавьте еще один файл в папку /data на хостовой машине;
* Подключитесь во второй контейнер и отобразите листинг и содержание файлов в /data контейнера.

</details>

### Ответ

```bash
nik@ubuntuVM:~/netology/3.1.Docker$ docker run -v $(pwd)/data/:/data -dt centos
nik@ubuntuVM:~/netology/3.1.Docker$ docker run -v $(pwd)/data/:/data -dt debian

nik@ubuntuVM:~/netology/3.1.Docker$ docker ps
CONTAINER ID   IMAGE                      COMMAND                  CREATED          STATUS          PORTS                               NAMES
c5c3cf7d5953   centos                     "/bin/bash"              2 seconds ago    Up 1 second                                         stoic_bell
ebf8cfd114e1   debian                     "bash"                   17 seconds ago   Up 15 seconds                                       stupefied_hamilton

nik@ubuntuVM:~/netology/3.1.Docker$ docker exec c5c3cf7d5953 bash -c "echo 'hello' > /data/test.txt"
nik@ubuntuVM:~/netology/3.1.Docker$ cd data
nik@ubuntuVM:~/netology/3.1.Docker/data$ sudo touch 123.txt

nik@ubuntuVM:~/netology/3.1.Docker/data$ docker exec ebf8cfd114e1 ls /data
123.txt
test.txt
```

### Задача 4

<details>
Воспроизвести практическую часть лекции самостоятельно.

Соберите Docker образ с Ansible, загрузите на Docker Hub и пришлите ссылку вместе с остальными ответами к задачам.
</details>

`https://hub.docker.com/repository/docker/nikolay480/ansible`

___

## Домашнее задание к занятию "4. Оркестрация группой Docker контейнеров на примере Docker Compose"

### Задача 1

<details>
Создать собственный образ операционной системы с помощью Packer.

Для получения зачета, вам необходимо предоставить:

Скриншот страницы, как на слайде из презентации (слайд 37).
</details>

### Ответ

![](images.png)

### Задача 2

<details>
Создать вашу первую виртуальную машину в Яндекс.Облаке.

Для получения зачета, вам необходимо предоставить:

Скриншот страницы свойств созданной ВМ, как на примере ниже:
</details>

### Ответ

![](2.YC-.png)

### Задача 3

<details>
Создать ваш первый готовый к боевой эксплуатации компонент мониторинга, состоящий из стека микросервисов.

Для получения зачета, вам необходимо предоставить:

Скриншот работающего веб-интерфейса Grafana с текущими метриками, как на примере ниже
</details> 

### Ответ

![](3.Grafana.png)

[](3.Grafana.png)

___

# Домашнее задание к занятию "5. Оркестрация кластером Docker контейнеров на примере Docker Swarm"

### Задача 1

<details>
Дайте письменые ответы на следующие вопросы:

В чём отличие режимов работы сервисов в Docker Swarm кластере: replication и global?
Какой алгоритм выбора лидера используется в Docker Swarm кластере?
Что такое Overlay Network?
</details>

### Ответ

В режиме `replicated` приложение запускается в том количестве экземпляров, какое укажет пользователь. При запуске
указывается количество идентичных задач, которое должно быть запущено. Желательно, чтобы количество узлов при этом было
большим, чем количество реплик – в этом случае Docker Swarm будет выполнять реплики на разных узлах.

В режиме `global`  служба выполняет одну задачу на каждом узле. Заранее определенного задач не существует.

Лидер нода выбирается из управляющих нод путем Raft согласованного алгоритма.
Сам `Raft-алгоритм` имеет ограничение на количество управляющих нод. Распределенные решения
должны быть одобрены большинством управляющих узлов, называемых кворумом. Это означает, что рекомендуется нечетное
количество управляющих узлов.

`Overlay-сети `используются в контексте кластеров (Docker Swarm), где виртуальная сеть, которую используют контейнеры,
связывает несколько физических хостов, на которых запущен Docker. Когда запускается контейнер на swarm-кластере (как
часть сервиса), множество сетей присоединяется по умолчанию, и каждая из них соответствует разным требованиям связи.
`Overlay-сеть ` создает подсеть, которую могут использовать контейнеры в разных хостах swarm-кластера. Контейнеры на
разных
физических хостах могут обмениваться данными по overlay-сети (если все они прикреплены к одной сети).

### Задача 2

Создать ваш первый Docker Swarm кластер в Яндекс.Облаке

Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:

`docker node ls`

### Ответ

![](node_ls.png)

### Задача 3

Создать ваш первый, готовый к боевой эксплуатации кластер мониторинга, состоящий из стека микросервисов.

Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:

`docker service ls`

### Ответ

![](service_ls.png)

### Задача 4 (*)

<details>
Выполнить на лидере Docker Swarm кластера команду (указанную ниже) и дать письменное описание её функционала, что она делает и зачем она нужна:

см.документацию: https://docs.docker.com/engine/swarm/swarm_manager_locking/
`docker swarm update --autolock=true`
</details>

![](autolock.png)

Чтобы включить автоматическую блокировку для существующего swarm, необходимо установить флаг autolock равным true.

При перезапуске Docker сначала необходимо разблокировать swarm, используя ключевой ключ шифрования, сгенерированный
Docker при блокировке swarm. Можно поменять этот ключевой ключ шифрования в любое время.

Для разблокировки требуется ввести `docker swarm unlock` и ключ расшифровки журналов RAFT
`docker swarm unlock-key` - показать ключ
`docker swarm unlock-key --rotate` - обновление времени жизни ключа

```bash
$docker swarm unlock

Please enter unlock key:
```

Необходимо ввести ключ шифрования, который был сгенерирован и показан в выводе команды, когда вы заблокировали swarm и


___

# Домашнее задание к занятию "6.1. Типы и структура СУБД"

## Задача 1

<details>
Архитектор ПО решил проконсультироваться у вас, какой тип БД лучше выбрать для хранения определенных данных.

Он вам предоставил следующие типы сущностей, которые нужно будет хранить в БД:

Электронные чеки в json виде
Склады и автомобильные дороги для логистической компании
Генеалогические деревья
Кэш идентификаторов клиентов с ограниченным временем жизни для движка аутентификации
Отношения клиент-покупка для интернет-магазина
Выберите подходящие типы СУБД для каждой сущности и объясните свой выбор.
</details>

### Ответ

* `Электронные чеки в json виде` - наиболее подойдет **документарная** БД, так как единицей хранения тут будет документ
  в формате JSON.
* `Склады и автомобильные дороги для логистической компании` - **сетевой** тип БД, который используют сетевую структуру
  для создания отношений между объектами. Тут "склады связаны сетью дорог".
* `Генеалогические деревья` - **графовый** тип БД, которые содержат узлы, отображающие объекты, а также ребра,
  отображающие отношения между ними - что как раз и необходимо при хранении и обработке данных гинеалогического дерева.
  Возможно могла бы подойти **иерархическая** БД, в которой данные организованы в древовидную структуру, но в ней каждая
  дочерняя запись имеет только одного родителя.
* `Кэш идентификаторов клиентов с ограниченным временем жизни для движка аутентификации`  - лучше выбрать базу по
  типу  **"ключ-значение"**. В этих БД запросы только на основе ключа — вы запрашиваете ключ и получаете его значение.
  Полезное свойство этих БД — поле времени жизни (Time-to-Live, TTL), в котором можно задать отдельно для каждой записи
  и
  состояния, когда их нужно удалить из БД.

* `Отношения клиент-покупка для интернет-магазина` - реляционная БД, так как база строится на отношениях между
  объектами (например, таблица товаров, таблица покупателей).

### Задача 2

<details>
Вы создали распределенное высоконагруженное приложение и хотите классифицировать его согласно CAP-теореме. Какой классификации по CAP-теореме соответствует ваша система, если (каждый пункт - это отдельная реализация вашей системы и для каждого пункта надо привести классификацию):
Данные записываются на все узлы с задержкой до часа (асинхронная запись)
При сетевых сбоях, система может разделиться на 2 раздельных кластера
Система может не прислать корректный ответ или сбросить соединение
А согласно PACELC-теореме, как бы вы классифицировали данные реализации?
</details>

### Ответ

* Данные записываются на все узлы с задержкой до часа (асинхронная запись)

`CAP - CA, PACELC - EL/PC`

* При сетевых сбоях, система может разделиться на 2 раздельных кластера

`CAP - AP , PACELC - PA/EL`

* Система может не прислать корректный ответ или сбросить соединение

`CAP - CP, PACELC - EC/PA`

### Задача 3

Могут ли в одной системе сочетаться принципы BASE и ACID? Почему?

### Ответ

Считаю что не могут, так как ACID и BASE противопоставляются друг другу. BASE ориентирована на производительность, и
имеет неустойчивое состояние, тогда как ACID обеспечивает высокую надежность и предсказуемость работы, фиксируются
только успешные транзакции.

### Задача 4

<details>
Вам дали задачу написать системное решение, основой которого бы послужили:

фиксация некоторых значений с временем жизни
реакция на истечение таймаута
Вы слышали о key-value хранилище, которое имеет механизм Pub/Sub. Что это за система? Какие минусы выбора данной
системы?
</details>


PUB-SUB(публикация-подписка) - это шаблон обмена сообщениями, в котором отправители сообщений, называемые издателями, не
программируют сообщения для отправки непосредственно конкретным получателям, называемым подписчиками, а вместо этого
разделяют опубликованные сообщения на классы, не зная, какие подписчики, если таковые имеются, могут быть.

### Ответ

Redis - БД типа ключ-значение с высокой производительностью.
Для достижения максимальной производительности Redis работает с набором данных в памяти. В зависимости от варианта
использования, Redis может сохранять данные либо путем периодического сброса набора данных на диск, либо
путем добавления каждой команды в журнал на диске.
Redis подходит для ситуаций, когда требуется очень быстрый доступ. Чаще всего он становится кэширующей прослойкой, в
которую выносят часть запрашиваемых данных. Это могут быть сохраненные пользовательские сессии, лента комментариев,
изображения с резервными копиями в других БД.
Платить за высокую производительность и удобство приходится **высоким риском потери данных**. Чтобы снизить вероятность
таких последствий, Redis сохраняет копии на жестком диске. Это помогает не потерять информацию в штатных ситуациях,
например при перезагрузке сервера. Но в аварийных случаях риски все равно остаются высокими.
Из-за особенностей работы систему не используют в качестве единственного хранилища. Часто разработчики настраивают
связку Redis MySQL или Redis PostgreSQL. При таком подходе инфраструктурные проблемы и аварии не приводят к потере
данных.

Редис может выступать в качестве брокера сообщений, однако к минусам здесь можно отнести:

`использование только тривиальной модели pub/sub`

`отсутствие очередей сообщений`

___

# Домашнее задание к занятию "6.2. SQL"

## Задача 1

<details>

Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.

`docker-compose.yaml`

```yaml
version: '3'
services:
  db:
    container_name: pgs12
    image: postgres:12
    environment:
      POSTGRES_USER: nikolay
      POSTGRES_PASSWORD: mysecret
      POSTGRES_DB: start_db
    ports:
      - "5432:5432"
    volumes:
      - database_volume:/home/database/
      - backup_volume:/home/backup/

volumes:
  database_volume:
  backup_volume:
```

</details>

## Задача 2

<details>
В БД из задачи 1:

* создайте пользователя test-admin-user и БД test_db

> test_db=# CREATE USER "test-admin-user";
>
> CREATE ROLE

* в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)

> test_db=# CREATE TABLE orders (id SERIAL PRIMARY KEY, наименование TEXT, цена INTEGER);
>
> CREATE TABLE

> test_db=# CREATE TABLE clients (id SERIAL PRIMARY KEY, фамилия TEXT, "страна проживания" TEXT, заказ INTEGER, FOREIGN
> KEY (заказ) REFERENCES orders (id));
>
> CREATE TABLE

* предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db

> test_db=# GRANT ALL ON TABLE orders, clients TO "test-admin-user";
>
>GRANT

* создайте пользователя test-simple-user

> test_db=# CREATE USER "test-simple-user" WITH PASSWORD '123456';
>
>CREATE ROLE
>

* предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db

> test_db=# GRANT SELECT, INSERT, UPDATE, DELETE ON orders, clients TO "test-simple-user";
>
>GRANT

Таблица orders:

* id (serial primary key)
* наименование (string)
* цена (integer)

Таблица clients:

* id (serial primary key)
* фамилия (string)
* страна проживания (string, index)
* заказ (foreign key orders)

Приведите:

* итоговый список БД после выполнения пунктов выше,

```bash
test_db=# \l
                                    List of databases
   Name    |  Owner  | Encoding |  Collate   |   Ctype    |      Access privileges       
-----------+---------+----------+------------+------------+------------------------------
 postgres  | nikolay | UTF8     | en_US.utf8 | en_US.utf8 | 
 start_db  | nikolay | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0 | nikolay | UTF8     | en_US.utf8 | en_US.utf8 | =c/nikolay                  +
           |         |          |            |            | nikolay=CTc/nikolay
 template1 | nikolay | UTF8     | en_US.utf8 | en_US.utf8 | =c/nikolay                  +
           |         |          |            |            | nikolay=CTc/nikolay
 test_db   | nikolay | UTF8     | en_US.utf8 | en_US.utf8 | =Tc/nikolay                 +
           |         |          |            |            | nikolay=CTc/nikolay         +
           |         |          |            |            | "test-simple-user"=c/nikolay+
           |         |          |            |            | "test-admin-user"=c/nikolay
(5 rows)
```

* описание таблиц (describe)

```bash
test_db=# \d+ clients
                                                      Table "public.clients"
      Column       |  Type   | Collation | Nullable |               Default               | Storage  | Stats target | Description 
-------------------+---------+-----------+----------+-------------------------------------+----------+--------------+-------------
 id                | integer |           | not null | nextval('clients_id_seq'::regclass) | plain    |              | 
 фамилия           | text    |           |          |                                     | extended |              | 
 страна проживания | text    |           |          |                                     | extended |              | 
 заказ             | integer |           |          |                                     | plain    |              | 
Indexes:
    "clients_pkey" PRIMARY KEY, btree (id)
    "clients_страна проживания_idx" btree ("страна проживания")
Foreign-key constraints:
    "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)
Access method: heap
```

```sh
test_db=# \d+ orders
                                                   Table "public.orders"
    Column    |  Type   | Collation | Nullable |              Default               | Storage  | Stats target | Description 
--------------+---------+-----------+----------+------------------------------------+----------+--------------+-------------
 id           | integer |           | not null | nextval('orders_id_seq'::regclass) | plain    |              | 
 наименование | text    |           |          |                                    | extended |              | 
 цена         | integer |           |          |                                    | plain    |              | 
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)
Access method: heap
```

* SQL-запрос для выдачи списка пользователей с правами над таблицами test_db

```sh
test_db=## 
SELECT grantee, table_name, privilege_type 
FROM information_schema.table_privileges 
WHERE table_name in ('clients','orders');
```

* список пользователей с правами над таблицами test_db

```
grantee      | table_name | privilege_type 
------------------+------------+----------------
 nikolay          | orders     | INSERT
 nikolay          | orders     | SELECT
 nikolay          | orders     | UPDATE
 nikolay          | orders     | DELETE
 nikolay          | orders     | TRUNCATE
 nikolay          | orders     | REFERENCES
 nikolay          | orders     | TRIGGER
 test-admin-user  | orders     | INSERT
 test-admin-user  | orders     | SELECT
 test-admin-user  | orders     | UPDATE
 test-admin-user  | orders     | DELETE
 test-admin-user  | orders     | TRUNCATE
 test-admin-user  | orders     | REFERENCES
 test-admin-user  | orders     | TRIGGER
 test-simple-user | orders     | INSERT
 test-simple-user | orders     | SELECT
 test-simple-user | orders     | UPDATE
 test-simple-user | orders     | DELETE
 nikolay          | clients    | INSERT
 nikolay          | clients    | SELECT
 nikolay          | clients    | UPDATE
 nikolay          | clients    | DELETE
 nikolay          | clients    | TRUNCATE
 nikolay          | clients    | REFERENCES
 nikolay          | clients    | TRIGGER
 test-admin-user  | clients    | INSERT
 test-admin-user  | clients    | SELECT
...skipping 1 line
 test-admin-user  | clients    | DELETE
 test-admin-user  | clients    | TRUNCATE
 test-admin-user  | clients    | REFERENCES
 test-admin-user  | clients    | TRIGGER
 test-simple-user | clients    | INSERT
 test-simple-user | clients    | SELECT
 test-simple-user | clients    | UPDATE
 test-simple-user | clients    | DELETE
(36 rows)
```

</details>

## Задача 3

<details>

Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

Таблица orders
>
> |Наименование|цена|
> |------------|----|
> |Шоколад| 10 |
> |Принтер| 3000 |
> |Книга| 500 |
> |Монитор| 7000|
> |Гитара| 4000|

Таблица clients
>
> |ФИО|Страна проживания|
> |------------|----|
> |Иванов Иван Иванович| USA |
> |Петров Петр Петрович| Canada |
> |Иоганн Себастьян Бах| Japan |
> |Ронни Джеймс Дио| Russia|
> |Ritchie Blackmore| Russia|

```sh
test_db=# INSERT INTO orders(наименование, цена)
VALUES
('Шоколад', 10),
('Принтер', 3000),
('Книга', 500),
('Монитор', 7000),
('Гитара', 4000);
INSERT 0 5
```

```sh
test_db=# INSERT INTO clients
VALUES
(1, 'Иванов Иван Иванович', 'USA'),
(2, 'Петров Петр Петрович', 'Canada'),
(3, 'Иоганн Себастьян Бах', 'Japan'),
(4, 'Ронни Джеймс Дио', 'Russia'),
(5, 'Ritchie Blackmore', 'Russia');
INSERT 0 5
```

Используя SQL синтаксис:

- вычислите количество записей для каждой таблицы
- приведите в ответе:
- запросы
- результаты их выполнения.

```sh
test_db=# SELECT count(*) FROM clients;
 count 
-------
     5
(1 row)

test_db=# SELECT count(*) FROM orders;
 count 
-------
     5
(1 row)
```

</details>

## Задача 4

<details>

Часть пользователей из таблицы `clients` решили оформить заказы из таблицы `orders`.

Используя `foreign keys` свяжите записи из таблиц, согласно таблице:

> ФИО | Заказ |

> Иванов Иван Иванович | Книга |

> Петров Петр Петрович | Монитор |

> Иоганн Себастьян Бах | Гитара |

Приведите SQL-запросы для выполнения данных операций.

Можно указать непосредственно ID заказа из таблицы orders:

```sh
test_db=# UPDATE clients SET "заказ" = 3 WHERE "фамилия"='Иванов Иван Иванович';
UPDATE 1
test_db=# UPDATE clients SET "заказ" = 4 WHERE "фамилия"='Петров Петр Петрович';
UPDATE 1
```

Или выполнить более сложный запрос:

```sh
test_db=# UPDATE clients SET "заказ" = (SELECT id FROM orders WHERE "наименование" = 'Гитара') WHERE "фамилия"='Иоганн Себастьян Бах';
UPDATE 1
```

Кроме того, если использовать ID заказа, который вне таблицы orders, благодаря использованию внешнего ключа выйдет
ошибка:

```sh
test_db=# UPDATE clients SET "заказ" = 10 WHERE "фамилия"='Иванов Иван Иванович';
ERROR:  insert or update on table "clients" violates foreign key constraint "clients_заказ_fkey"
DETAIL:  Key (заказ)=(10) is not present in table "orders".
```

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.

```sh
test_db=# SELECT * FROM clients WHERE заказ IS NOT NULL;
 id |       фамилия        | страна проживания | заказ 
----+----------------------+-------------------+-------
  1 | Иванов Иван Иванович | USA               |     3
  2 | Петров Петр Петрович | Canada            |     4
  3 | Иоганн Себастьян Бах | Japan             |     5
(3 rows)
```

Или:

```sh
test_db=# SELECT id, фамилия, "страна проживания" FROM clients WHERE заказ IS NOT NULL;
 id |       фамилия        | страна проживания 
----+----------------------+-------------------
  1 | Иванов Иван Иванович | USA
  2 | Петров Петр Петрович | Canada
  3 | Иоганн Себастьян Бах | Japan
(3 rows)
```

Подсказкa - используйте директиву UPDATE.
</details>

## Задача 5

<details>
Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 (используя директиву EXPLAIN).
Приведите получившийся результат и объясните что значат полученные значения.

```sh
test_db=# EXPLAIN SELECT * FROM clients WHERE заказ IS NOT NULL;
                        QUERY PLAN                         
-----------------------------------------------------------
 Seq Scan on clients  (cost=0.00..18.10 rows=806 width=72)
   Filter: ("заказ" IS NOT NULL)
(2 rows)
```

Результат вывода команды показывает, что во время запроса выполнено последовательное чтение данных `Seq Scan`,

'трудозатраты' на чтение всех строк `cost = 18.10

приблизительное количество возвращаемых строк при выполнении операции - `rows=806 `

средний размер одной строки в байтах w`idth=72`

В запросе использован Filter, где поле заказ не пустое.

</details>

## Задача 6

<details>
Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).

Остановите контейнер с PostgreSQL (но не удаляйте volumes).

Поднимите новый пустой контейнер с PostgreSQL.

Восстановите БД test_db в новом контейнере.

Приведите список операций, который вы применяли для бэкапа данных и восстановления.

Проверим расположение базы данных test_db

```sh
test_db=# show data_directory;
      data_directory      
--------------------------
 /var/lib/postgresql/data
(1 row
```

Копируем БД в /home/backup

```postgres@b705978ca712:~$ cp -r /var/lib/postgresql/data /home/backup
postgres@b705978ca712:~$ ls -la /home/backup
total 12
drwxrwxrwx  3 root     root     4096 Nov 30 19:38 .
drwxr-xr-x  1 root     root     4096 Nov 29 14:53 ..
drwx------ 19 postgres postgres 4096 Nov 30 19:38 data
```

```sh
nik@ubuntuVM:/home$ docker run  --rm -e POSTGRES_PASSWORD=12345678 --volumes-from pgs12 -d --name pgs12-2 postgres:12
e23227f0dc060985688045dc8fd7cc9f3207ee94640a921d5f5bd54889385b97
nik@ubuntuVM:/home$ docker ps -a
CONTAINER ID   IMAGE         COMMAND                  CREATED          STATUS                      PORTS      NAMES
e23227f0dc06   postgres:12   "docker-entrypoint.s…"   42 seconds ago   Up 40 seconds               5432/tcp   pgs12-2
b705978ca712   postgres:12   "docker-entrypoint.s…"   2 days ago       Exited (0) 51 minutes ago              pgs12
nik@ubuntuVM:/home$ docker exec -it pgs12-2 bash
root@e23227f0dc06:/# ls /home/backup
data
root@e23227f0dc06:/# psql -U nikolay -d test_db 
psql (12.13 (Debian 12.13-1.pgdg110+1))
Type "help" for help.

test_db=# \d
              List of relations
 Schema |      Name      |   Type   |  Owner  
--------+----------------+----------+---------
 public | clients        | table    | nikolay
 public | clients_id_seq | sequence | nikolay
 public | orders         | table    | nikolay
 public | orders_id_seq  | sequence | nikolay
(4 rows)
```

</details>

___

# Домашнее задание к занятию "6.3. MySQL"

#

[дополнительные материалы](https://github.com/netology-code/virt-homeworks/blob/virt-11/additional/README.md)

## Задача 1

<details>
Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.

```yaml
version: '3.8'
services:
  db:
    image: mysql:8.0
    cap_add:
      - SYS_NICE
    restart: always
    environment:
      - MYSQL_DATABASE=quotes
      - MYSQL_ROOT_PASSWORD=mysecret
    ports:
      - '3306:3306'
    volumes:
      - db:/var/lib/mysql
      - ./db/init.sql:/docker-entrypoint-initdb.d/init.sql
volumes:
  db:
    driver: local
```    

> `docker compose -f "docker-compose_mysql.yaml" up -d --build `


Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/virt-11/06-db-03-mysql/test_data) и
восстановитесь из него.

```shell
nik@ubuntuVM:~/netology/6.SQL/MySQL$ docker ps
CONTAINER ID   IMAGE       COMMAND                  CREATED              STATUS              PORTS                                                  NAMES
7e99d5f40931   mysql:8.0   "docker-entrypoint.s…"   About a minute ago   Up About a minute   0.0.0.0:3306->3306/tcp, :::3306->3306/tcp, 33060/tcp   mysql-db-1
```

```shell

nik@ubuntuVM:~/netology/6.SQL/MySQL$ docker cp test_dump.sql mysql-db-1:/var/tmp/test_dump.sql
nik@ubuntuVM:~/netology/6.SQL/MySQL$ docker exec -it mysql-db-1 bash
bash-4.4# mysql -u root -p quotes  < /var/tmp/test_dump.sql
Enter password: 

```

Перейдите в управляющую консоль `mysql` внутри контейнера.

```shell
bash-4.4# mysql -u root -p quotes                          
Enter password: 
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 13
Server version: 8.0.31 MySQL Community Server - GPL

Copyright (c) 2000, 2022, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement
```

Используя команду `\h` получите список управляющих команд.

Найдите команду для выдачи статуса БД и **приведите в ответе** из ее вывода версию сервера БД.
> Server version:         8.0.31 MySQL Community Server - GPL

```shell

mysql> \s
--------------
mysql  Ver 8.0.31 for Linux on x86_64 (MySQL Community Server - GPL)

Connection id:          20
Current database:
Current user:           root@localhost
SSL:                    Not in use
Current pager:          stdout
Using outfile:          ''
Using delimiter:        ;
Server version:         8.0.31 MySQL Community Server - GPL
Protocol version:       10
Connection:             Localhost via UNIX socket
Server characterset:    utf8mb4
Db     characterset:    utf8mb4
Client characterset:    latin1
Conn.  characterset:    latin1
UNIX socket:            /var/run/mysqld/mysqld.sock
Binary data as:         Hexadecimal
Uptime:                 27 min 44 sec

Threads: 2  Questions: 117  Slow queries: 0  Opens: 196  Flush tables: 3  Open tables: 111  Queries per second avg: 0.070
--------------
```

Подключитесь к восстановленной БД и получите список таблиц из этой БД.

```shell
mysql> USE quotes
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> SHOW TABLES;
+------------------+
| Tables_in_quotes |
+------------------+
| orders           |
+------------------+
1 row in set (0.00 sec)
```

**Приведите в ответе** количество записей с `price` > 300

```shell
mysql> SELECT * FROM orders WHERE price > 300;
+----+----------------+-------+
| id | title          | price |
+----+----------------+-------+
|  2 | My little pony |   500 |
+----+----------------+-------+
1 row in set (0.00 sec)
```

В следующих заданиях мы будем продолжать работу с данным контейнером.
_________________________________________

</details>

## Задача 2

<details>

Создайте пользователя test в БД c паролем test-pass, используя:

- плагин авторизации mysql_native_password
- срок истечения пароля - 180 дней
- количество попыток авторизации - 3
- максимальное количество запросов в час - 100
- аттрибуты пользователя:
    - Фамилия "Pretty"
    - Имя "James"

```shell
mysql>
CREATE USER 'test'@'localhost' 
IDENTIFIED WITH mysql_native_password BY 'test-pass'
WITH MAX_CONNECTIONS_PER_HOUR 100
PASSWORD EXPIRE INTERVAL 180 DAY
FAILED_LOGIN_ATTEMPTS 3 PASSWORD_LOCK_TIME 2
ATTRIBUTE '{"first_name":"James", "last_name":"Pretty"}';

Query OK, 0 rows affected (0.02 sec)
```

Предоставьте привелегии пользователю `test` на операции SELECT базы `test_db`.

```shell
mysql> GRANT SELECT ON quotes.* TO test@localhost;
Query OK, 0 rows affected, 1 warning (0.02 sec)
```

Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю `test` и
**приведите в ответе к задаче**.

```bash
mysql> SELECT * FROM INFORMATION_SCHEMA.USER_ATTRIBUTES WHERE USER='test';

+------+-----------+------------------------------------------------+
| USER | HOST      | ATTRIBUTE                                      |
+------+-----------+------------------------------------------------+
| test | localhost | {"last_name": "Pretty", "first_name": "James"} |
+------+-----------+------------------------------------------------+
1 row in set (0.00 sec)
```

___
</details>

## Задача 3

<details>

Установите профилирование `SET profiling = 1`.
Изучите вывод профилирования команд `SHOW PROFILES;`.

Исследуйте, какой `engine` используется в таблице БД `test_db` и **приведите в ответе**.

```bash
mysql
> SELECT table_schema,table_name,engine FROM information_schema.tables WHERE table_schema = 'quotes';
+--------------+------------+--------+
| TABLE_SCHEMA | TABLE_NAME | ENGINE |
+--------------+------------+--------+
| quotes       | orders     | InnoDB |
+--------------+------------+--------+
1 row in set (0.01 sec)
```

Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе**:

- на `MyISAM`
- на `InnoDB`

```shell
mysql> ALTER TABLE orders ENGINE = MyISAM;
Query OK, 5 rows affected (0.12 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> ALTER TABLE orders ENGINE = InnoDB;
Query OK, 5 rows affected (0.12 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> SHOW PROFILES;
+----------+------------+------------------------------------------------------------------------------------------------------+
| Query_ID | Duration   | Query                                                                                                |
+----------+------------+------------------------------------------------------------------------------------------------------+
|        1 | 0.00008400 | SHOW PROFILES ALL                                                                                    |
|        ......                                                    |
         ....
|        7 | 0.12425150 | ALTER TABLE orders ENGINE = MyISAM                                                                   |
|        8 | 0.12438275 | ALTER TABLE orders ENGINE = InnoDB                                                                   |
+----------+------------+------------------------------------------------------------------------------------------------------+
```

___
</details>

## Задача 4

<details>
Изучите файл `my.cnf` в директории /etc/mysql.

Измените его согласно ТЗ (движок InnoDB):

- Скорость IO важнее сохранности данных
- Нужна компрессия таблиц для экономии места на диске
- Размер буффера с незакомиченными транзакциями 1 Мб
- Буффер кеширования 30% от ОЗУ
- Размер файла логов операций 100 Мб

Приведите в ответе измененный файл `my.cnf`

```bash
bash-4.4# cat /etc/my.cnf
# For advice on how to change settings please see
# http://dev.mysql.com/doc/refman/8.0/en/server-configuration-defaults.html

[mysqld]
#
# Remove leading # and set to the amount of RAM for the most important data
# cache in MySQL. Start at 70% of total RAM for dedicated server, else 10%.
# innodb_buffer_pool_size = 128M
#
# Remove leading # to turn on a very important data integrity option: logging
# changes to the binary log between backups.
# log_bin
#
# Remove leading # to set options mainly useful for reporting servers.
# The server defaults are faster for transactions and fast SELECTs.
# Adjust sizes as needed, experiment to find the optimal values.
# join_buffer_size = 128M
# sort_buffer_size = 2M
# read_rnd_buffer_size = 2M

# Remove leading # to revert to previous value for default_authentication_plugin,
# this will increase compatibility with older clients. For background, see:
# https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html#sysvar_default_authentication_plugin
# default-authentication-plugin=mysql_native_password
skip-host-cache
skip-name-resolve
datadir=/var/lib/mysql
socket=/var/run/mysqld/mysqld.sock
secure-file-priv=/var/lib/mysql-files
user=mysql

pid-file=/var/run/mysqld/mysqld.pid
[client]
socket=/var/run/mysqld/mysqld.sock

!includedir /etc/mysql/conf.d/

innodb_flush_log_at_trx_commit = 2   # Скорость IO важнее сохранности данных
innodb_file_per_table = ON           # Нужна компрессия таблиц для экономии места на диске. таблицы хранятся по разным файла
innodb_log_buffer_size = 1M          # Размер буффера с незакомиченными транзакциями 1 Мб
innodb_buffer_pool_size = 1.7G       # Буффер кеширования 30% от ОЗУ
innodb_log_file_size = 100M          # Размер файла логов операций 100 Мб
```

___
</details>

___

# Домашнее задание к занятию "6.4. PostgreSQL"

## Задача 1

<details>

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.
`docker compose -f "docker-compose-postgres.yaml" up -d --build`

```yaml
version: '3.8'
volumes:
  pg13vol:
services:
  pg_db:
    image: postgres:13
    restart: always
    environment:
      - POSTGRES_PASSWORD=mysecret
    volumes:
      - pg13vol:/var/lib/postgresql/data
    ports:
      - 5432:5432
```

```bash
nik@ubuntuVM:~/netology/6.SQL/MySQL$ docker ps
CONTAINER ID   IMAGE         COMMAND                  CREATED          STATUS         PORTS                                       NAMES
a7126bb61621   postgres:13   "docker-entrypoint.s…"   13 seconds ago   Up 9 seconds   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   postgres-pg_db-1
nik@ubuntuVM:~/netology/6.SQL/MySQL$ docker exec -it postgres-pg_db-1 bash
```

Подключитесь к БД PostgreSQL используя `psql`.

```bash
root@a7126bb61621:/# psql -U postgres
psql (13.9 (Debian 13.9-1.pgdg110+1))
Type "help" for help.
```

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:

- вывода списка

> \l

- подключения к БД

> `\c[onnect] {[DBNAME|- USER|- HOST|- PORT|-] | conninfo}`  - connect to new database (currently "postgres"

> `\conninfo ` - display information about current connection

```bash
postgres=# \conninfo
You are connected to database "postgres" as user "postgres" via socket in "/var/run/postgresql" at port "5432".
```

- вывода списка таблиц

> `\dt[S] [PATTERN] `     list tables

```bash
postgres=# \dtS
                    List of relations
   Schema   |          Name           | Type  |  Owner   
------------+-------------------------+-------+----------
 pg_catalog | pg_aggregate            | table | postgres
 pg_catalog | pg_am                   | table | postgres
 pg_catalog | pg_amop                 | table | postgres
 pg_catalog | pg_amproc               | table | postgres
 pg_catalog | pg_attrdef              | table | postgres
 pg_catalog | pg_attribute            | table | postgres
 pg_catalog | pg_auth_members         | table | postgres
```

- вывода описания содержимого таблиц

> `\dS+` - list tables

> (options: S = show system objects, + = additional detail)

```bash
postgres=# \dtS+
                                        List of relations
   Schema   |          Name           | Type  |  Owner   | Persistence |    Size    | Description 
------------+-------------------------+-------+----------+-------------+------------+-------------
 pg_catalog | pg_aggregate            | table | postgres | permanent   | 56 kB      | 
 pg_catalog | pg_am                   | table | postgres | permanent   | 40 kB      | 
```

- выхода из psql

```bash
> `\q`   - quit psql
```

</details>

## Задача 2

<details>
Используя `psql` создайте БД `test_database`.
```bash
postgres=# CREATE DATABASE test_database;
CREATE DATABASE
```


Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/virt-11/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.

```bash
postgres@a7126bb61621:/$ psql -d test_database < /tmp/test_dump.sql
````

<details>

```bash
SET
SET
SET
SET
SET
 set_config 
------------
 
(1 row)

SET
SET
SET
SET
SET
SET
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
COPY 8
 setval 
--------
      8
(1 row)

ALTER TABLE
```

</details>

Перейдите в управляющую консоль `psql` внутри контейнера.

```bash
postgres@a7126bb61621:/$ psql
psql (13.9 (Debian 13.9-1.pgdg110+1))
Type "help" for help.

```

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

```bash
postgres=# \c test_database 
You are now connected to database "test_database" as user "postgres".
test_database=# ANALYZE VERBOSE orders;
INFO:  analyzing "public.orders"
INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 0 dead rows; 8 rows in sample, 8 estimated total rows
ANALYZE

```

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders`
с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.

```bash
test_database=# SELECT tablename, avg_width FROM pg_stats  WHERE avg_width = (SELECT max(avg_width) FROM pg_stats WHERE tablename = 'orders');
 tablename | avg_width 
-----------+-----------
 orders    |        16
(1 row)
```

</details>

## Задача 3

<details>
Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.

[Масштабирование базы данных через шардирование и партиционирование](https://habr.com/ru/company/oleg-bunin/blog/309330/)
[Партицирование таблиц в PostgreSQL: чек-лист для старта](https://habr.com/ru/company/skyeng/blog/583222/)

```bash
test_database=# CREATE TABLE orders_1 (CHECK (price > 499)) INHERITS (orders);
CREATE TABLE
test_database=# CREATE TABLE orders_2 (CHECK (price <= 499)) INHERITS (orders);
CREATE TABLE
test_database=# INSERT INTO orders_1 (SELECT * FROM orders WHERE price > 499);
INSERT 0 3
test_database=# INSERT INTO orders_2 (SELECT * FROM orders WHERE price <= 499);
INSERT 0 5
``` 

Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

`Можно, допустим через использование декларативного разделения`

`CREATE TABLE orders_1 PARTITION OF orders ...`
</details>

## Задача 4

<details>
Используя утилиту `pg_dump` создайте бекап БД `test_database`.
```bash
postgres@a7126bb61621:/$ pg_dump -d test_database > /tmp/dump_test_database.sql
```

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?

```
CREATE TABLE public.orders (
    id integer NOT NULL,
    title character varying(80) CONSTRAINT must_be_different UNIQUE, # добавить ограничение уникальности на столбец `title` 
    price integer DEFAULT 0
);
```

</details>

___

# Домашнее задание к занятию "6.5. Elasticsearch"

## Задача 1

<details>
В этом задании вы потренируетесь в:
- установке elasticsearch
- первоначальном конфигурировании elastcisearch
- запуске elasticsearch в docker

Используя докер образ [centos:7](https://hub.docker.com/_/centos) как базовый и
[документацию по установке и запуску Elastcisearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html):

- составьте Dockerfile-манифест для elasticsearch
- соберите docker-образ и сделайте `push` в ваш docker.io репозиторий
- запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины

Требования к `elasticsearch.yml`:

- данные `path` должны сохраняться в `/var/lib`
- имя ноды должно быть `netology_test`

В ответе приведите:

- текст Dockerfile манифеста

```yaml
FROM centos:7

EXPOSE 9200

ARG ES_HOME=/var/lib/elasticsearch
ARG ES_PATH_CONF=/var/lib/elasticsearch/config

COPY ./elasticsearch-7.15.0-linux-x86_64.tar.gz .

RUN mkdir /var/lib/elasticsearch && \
mkdir /var/lib/elasticsearch/config

RUN tar -xzf /elasticsearch-7.15.0-linux-x86_64.tar.gz && \
cp -r elasticsearch-7.15.0/* ${ES_HOME} && \
rm -r elasticsearch-7.15.0

RUN adduser elastic && chown -R elastic ${ES_HOME} && chown -R elastic /var/lib

COPY --chown=elastic config/* ${ES_PATH_CONF}

USER elastic

ENV ES_HOME="/var/lib/elasticsearch/" \
ES_PATH_CONF="/var/lib/elasticsearch/config"

WORKDIR ${ES_HOME}

CMD "${ES_HOME}/bin/elasticsearch"
```

- ссылку на образ в репозитории
  `https://hub.docker.com/repository/docker/nikolay480/elastic`

- ответ `elasticsearch` на запрос пути `/` в json виде

```bash
[elastic@e5b0830d78e8 elasticsearch]$ export ES_URL=localhost:9200

[elastic@3456f4e8cd6b elasticsearch]$ curl $ES_URL
{
  "name" : "netology_test",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "Ca_aVo2vRqCMipTh8jVuQA",
  "version" : {
    "number" : "7.15.0",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "79d65f6e357953a5b3cbcc5e2c7c21073d89aa29",
    "build_date" : "2021-09-16T03:05:29.143308416Z",
    "build_snapshot" : false,
    "lucene_version" : "8.9.0",
    "minimum_wire_compatibility_version" : "6.8.0",
    "minimum_index_compatibility_version" : "6.0.0-beta1"
  },
  "tagline" : "You Know, for Search"
}
```

Подсказки:

- возможно вам понадобится установка пакета perl-Digest-SHA для корректной работы пакета shasum
- при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml
- при некоторых проблемах вам поможет docker директива ulimit
- elasticsearch в логах обычно описывает проблему и пути ее решения

Далее мы будем работать с данным экземпляром elasticsearch.

</details>

## Задача 2

<details>

В этом задании вы научитесь:

- создавать и удалять индексы
- изучать состояние кластера
- обосновывать причину деградации доступности данных

Ознакомтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html)
и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

> Добавление индексов

``` bash
[elastic@e5b0830d78e8 elasticsearch]$ curl -X PUT "$ES_URL/ind-1?pretty" -H "Content-Type:application/json" -d '{"settings": {"index": {"number_of_shards": 1, "number_of_replicas": 0}}}'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "ind-1"
}
[elastic@e5b0830d78e8 elasticsearch]$ curl -X PUT "$ES_URL/ind-2?pretty" -H "Content-Type:application/json" -d '{"settings": {"index": {"number_of_shards": 2, "number_of_replicas": 1}}}'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "ind-2"
}
[elastic@e5b0830d78e8 elasticsearch]$ curl -X PUT "$ES_URL/ind-3?pretty" -H "Content-Type:application/json" -d '{"settings": {"index": {"number_of_shards": 2, "number_of_replicas": 4}}}'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "ind-3"
}
```

Получите список индексов и их статусов, используя API и **приведите в ответе**

```bash
[elastic@e5b0830d78e8 elasticsearch]$ curl $ES_URL/_cat/indices  
green  open .geoip_databases JmBXdUjBQR-tVSbHBuz1Ig 1 0 40 0 38mb 38mb
green  open ind-1            r1Eith1aS8uL0KSDWIFHUQ 1 0  0 0 208b 208b
yellow open ind-3            i4xdIHtWTnOUhEq_SahVqA 2 4  0 0 416b 416b
yellow open ind-2            qieCV0TTSGGlhdNVnkHJhQ 2 1  0 0 416b 416b
```

Получите состояние кластера `elasticsearch`, используя API.

```bash
[elastic@e5b0830d78e8 elasticsearch]$ curl -X GET "$ES_URL/_cluster/health?pretty"
{
  "cluster_name" : "elasticsearch",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 6,
  "active_shards" : 6,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 10,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 37.5
}
```

Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?

`YELLOW статус указывает, что один или несколько сегментов реплики в кластере Elasticsearch не выделены узлу.
Пока статус желтый, операции поиска и индексации по-прежнему доступны.
Elasticsearch никогда не назначит реплику тому же узлу, что и prime shard. Аналогично, если количество реплик равно или
превышает количество узлов, то невозможно будет выделить один или несколько сегментов по той же причине.`

Удалите все индексы.

`[elastic@e5b0830d78e8 elasticsearch]$ curl -X DELETE $ES_URL/ind-{1..3}
`

**Важно**

При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард,
иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.

</details>

## Задача 3

<details>
В данном задании вы научитесь:

- создавать бэкапы данных
- восстанавливать индексы из бэкапов

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.

Используя
API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository)
данную директорию как `snapshot repository` c именем `netology_backup`.

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.

``` bash
[elastic@a2b11c9d9e6f elasticsearch]$ curl -X PUT -H "Content-Type:application/json" -d '{"type": "fs", "settings": {"location": "/var/lib/elasticsearch/snapshots"}}' $ES_URL/_snapshot/netology_backup
{"acknowledged":true}
elastic@a2b11c9d9e6f elasticsearch]$ curl http://localhost:9200/_snapshot/netology_backup
{"netology_backup":{"type":"fs","settings":{"location":"/var/lib/elasticsearch/snapshots"}}} 
```

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.

```bash

[elastic@a2b11c9d9e6f elasticsearch]$ curl -X PUT -H "Content-Type:application/json" -d '{"settings": {"index": {"number_of_shards": 1, "number_of_replicas": 0}}}' $ES_URL/test
{"acknowledged":true,"shards_acknowledged":true,"index":"test"}

[elastic@a2b11c9d9e6f ~]$ curl $ES_URL/_cat/indices 
green open .geoip_databases E-UdPMaOST-tHvxwiGR1CQ 1 0 40 0 38mb 38mb
green open test             Fyrp6i5oTFyR4DhVWvm2gA 1 0  0 0 208b 208b

```

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html)
состояния кластера `elasticsearch`.

```bash
[elastic@e19b62d98ac1 elasticsearch]$ curl -X PUT localhost:9200/_snapshot/netology_backup/snapshot_1?wait_for_completion=true
{"snapshot":{"snapshot":"snapshot_1","uuid":"IsvwvZZaS7q5LQR8UvCJjw","repository":"netology_backup","version_id":7150099,"version":"7.15.0","indices":
[".geoip_databases","test"],"data_streams":[],"include_global_state":true,"state":"SUCCESS","start_time":"2022-12-10T17:09:41.958Z","start_time_in_millis":1670692181958,
"end_time":"2022-12-10T17:09:43.165Z","end_time_in_millis":1670692183165,"duration_in_millis":1207,"failures":[],"shards":{"total":2,"failed":0,"successful":2},
"feature_states":[{"feature_name":"geoip","indices":[".geoip_databases"]}]}}
```

**Приведите в ответе** список файлов в директории со `snapshot`ами.

```bash
[elastic@e19b62d98ac1 elasticsearch]$ ls -lah /var/lib/elasticsearch/snapshots
total 56K
drwxr-xr-x 3 elastic root    4.0K Dec 10 17:09 .
drwxr-xr-x 1 elastic root    4.0K Dec 10 16:28 ..
-rw-r--r-- 1 elastic elastic  828 Dec 10 17:09 index-0
-rw-r--r-- 1 elastic elastic    8 Dec 10 17:09 index.latest
drwxr-xr-x 4 elastic elastic 4.0K Dec 10 17:09 indices
-rw-r--r-- 1 elastic elastic  27K Dec 10 17:09 meta-IsvwvZZaS7q5LQR8UvCJjw.dat
-rw-r--r-- 1 elastic elastic  437 Dec 10 17:09 snap-IsvwvZZaS7q5LQR8UvCJjw.dat

```

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.

```bash
elastic@e19b62d98ac1 elasticsearch]$ curl -X DELETE http://localhost:9200/test
{"acknowledged":true}
```

```bash
curl -X PUT -H "Content-Type:application/json" -d '{"settings": {"index": {"number_of_shards": 1, "number_of_replicas": 0}}}' http://localhost:9200/test-2
{"acknowledged":true,"shards_acknowledged":true,"index":"test-2"

elastic@e19b62d98ac1 elasticsearch]$ curl localhost:9200/_cat/indices  
green open .geoip_databases Dkw3dXHUT6G8Y6pMTvG7wA 1 0 40 0 38mb 38mb
green open test-2           d-2TGzvBQzOsrIfrT7Oc7A 1 0  0 0 208b 208b

```

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html)
состояние
кластера `elasticsearch` из `snapshot`, созданного ранее.

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.

```bash
elastic@e19b62d98ac1 elasticsearch]$ curl -X POST "localhost:9200/_snapshot/netology_backup/snapshot_1/_restore?pretty" -H 'Content-Type: application/json' -d '{"indices": "*","include_global_state": true}'
{
  "accepted" : true
}
```

```bash
[elastic@e19b62d98ac1 elasticsearch]$ curl 'localhost:9200/_cat/indices?pretty'
green open .geoip_databases dI0VT978SGOTRjkKwyL-BQ 1 0 40 0 38mb 38mb
green open test-2           d-2TGzvBQzOsrIfrT7Oc7A 1 0  0 0 208b 208b
green open test             y4jQ1_3mT0ecTdUIvt7EKQ 1 0  0 0 208b 208b
```

Подсказки:

- возможно вам понадобится доработать `elasticsearch.yml` в части директивы `path.repo` и перезапустить `elasticsearch`

</details>

___

# Домашнее задание к занятию "6.6. Troubleshooting"

## Задача 1

<details>
Перед выполнением задания ознакомьтесь с документацией
по [администрированию MongoDB](https://docs.mongodb.com/manual/administration/).

Пользователь (разработчик) написал в канал поддержки, что у него уже 3 минуты происходит CRUD операция в MongoDB и её
нужно прервать.

Вы как инженер поддержки решили произвести данную операцию:

- напишите список операций, которые вы будете производить для остановки запроса пользователя


- предложите вариант решения проблемы с долгими (зависающими) запросами в MongoDB

## Ответ

Необходимо определить зависшую операцию.

` db.killOp(<opId>)`.
Метод прерывает выполнение операции в следующей точке прерывания (точка в жизненном цикле операции, когда ее
можно безопасно прервать).

На будущее можно включить профилирование `db.setProfilingLevel(1)`, указав пороговое значение для медленных операций
`--slowm`s, либо изменить в файле конфигурации параметр `slowOpThresholdMs`. Затем анализировать длительные запросы c
помощью `explain`.

Также в MongoDB есть возможность добавить `maxTimeMS` в команду, чтобы установить ограничение по времени для выполнения
операции:

Например:

```bash
db.runCommand( { distinct: "collection",
                 key: "city",
                 maxTimeMS: 45 } )
```

</details>

## Задача 2

<details>

Перед выполнением задания познакомьтесь с документацией
по [Redis latency troobleshooting](https://redis.io/topics/latency).

Вы запустили инстанс Redis для использования совместно с сервисом, который использует механизм TTL.
Причем, отношение количества записанных key-value значений к количеству истёкших значений есть величина постоянная и
увеличивается пропорционально количеству реплик сервиса.

При масштабировании сервиса до N реплик вы увидели, что:

- сначала рост отношения записанных значений к истекшим
- Redis блокирует операции записи

Как вы думаете, в чем может быть проблема?

> Eсли в базе данных очень много ключей, срок действия которых истекает в одну и ту же секунду, и они составляют не
> менее
> 25% от текущего набора ключей с истекшим сроком действия, Redis может заблокировать операции, чтобы процент ключей,
> срок
> действия
> которых уже истек, был ниже 25%.

</details>

## Задача 3

<details>

Вы подняли базу данных MySQL для использования в гис-системе. При росте количества записей, в таблицах базы,
пользователи начали жаловаться на ошибки вида:

```bash
InterfaceError: (InterfaceError) 2013: Lost connection to MySQL server during query u'SELECT..... '
```

Как вы думаете, почему это начало происходить и как локализовать проблему?

Какие пути решения данной проблемы вы можете предложить?

Согласно  [документации](https://dev.mysql.com/doc/refman/8.0/en/error-lost-connection.html) причинами могут быть:

- Проблемы с подключением к сети - следует проверить состояние сети.
- Объемный запрос с большим количеством строк, который не успевает выполниться - нужно попробовать изменить
  параметр `net_read_timeout`с 30 секунд по умолчанию на 60 или более.
- Если клиент пытается установить первоначальное соединение с сервером. В этом случае, если значение `connect_timeout`
  установлено всего на несколько секунд, можно увеличитьего до десяти секунд, возможно, больше, если медленное
  соединение.

Также полезным будет проверить размер буфера `max_allowed_packet` на сервере или `max_allowed_packet` на стороне
клиента.
</details>

## Задача 4

<details>
Вы решили перевести гис-систему из задачи 3 на PostgreSQL, так как прочитали в документации, что эта СУБД работает с
большим объемом данных лучше, чем MySQL.

После запуска пользователи начали жаловаться, что СУБД время от времени становится недоступной. В dmesg вы видите, что:

`postmaster invoked oom-killer`

Как вы думаете, что происходит?

> В ядре Linux есть функция, называемая `Out Of Memory Killer` (или OOM Killer), отвечающая за решение проблемы
> исчерпания
> памяти. Если система достигает точки, когда у нее может скоро закончиться вся память, OOM Killer ищет процесс, который
> нужно завершить.
> Чем больше памяти использует процесс, тем больше вероятность его уничтожения.
> Когда принудительно завершается процесс PostgreSQL, в логе появляется
> сообщение `Out of Memory: Killed process 12345 (postgres).`

Как бы вы решили данную проблему?

> При наличии возможности - увеличить объем ОЗУ и ограничить Postgres в использовании ресурсов хоста
> через [параметры](https://postgrespro.ru/docs/postgresql/14/runtime-config-resource#RUNTIME-CONFIG-RESOURCE-MEMORY) в
> конфиг-файле, например:

`shared_buffers`  - устанавливает, сколько выделенной памяти будет использоваться PostgreSQL для кеширования.
Рекомендуемое значение составляет 25% от общего объема оперативной памяти компьютера. В системах с объёмом ОЗУ меньше 1
ГБ стоит ограничиться меньшим процентом ОЗУ, чтобы оставить достаточно места операционной системе.

`wal_buffers` -  PostgreSQL сначала записывает записи в WAL (журнал предзаписи) в буферы, а затем эти буферы сбрасываются
на диск. Размер буфера по умолчанию, определенный wal_buffers, составляет 16 МБ.

`work_mem` - задаёт базовый максимальный объём памяти, который будет использоваться во внутренних операциях при
обработке запросов (например, для сортировки или хеш-таблиц), прежде чем будут задействованы временные файлы на диске.
Значение по умолчанию — четыре мегабайта (4MB).

`maintenance_work_mem` - задаёт максимальный объём памяти для операций обслуживания БД, в частности VACUUM, CREATE INDEX
и ALTER TABLE ADD FOREIGN KEY. Значение по умолчанию — 64MB. когда выполняется автоочистка, этот объём может быть
выделен autovacuum_max_workers раз, поэтому не стоит устанавливать значение по умолчанию слишком большим. Возможно,
будет лучше управлять объёмом памяти для автоочистки отдельно, изменяя `autovacuum_work_mem`.

`autovacuum_work_mem` - задаёт максимальный объём памяти, который будет использовать каждый рабочий процесс автоочистки.
При действующем по умолчанию значении -1 этот объём определяется значением `maintenance_work_mem`.

`effective_cache_size` - предоставляет оценку памяти, доступной для кэширования диска. Это всего лишь ориентир, а не
точный объем выделенной памяти или кеша. Он не выделяет фактическую память, но сообщает оптимизатору объем кеша, доступный в
ядре. Если значение этого параметра установлено слишком низким, планировщик запросов может принять решение не
использовать некоторые индексы, даже если они будут полезны.

> стоит отметить, что настройки индивидуальны и зависят как от используемого "железа", так и от типа сервисов. 
</details>

---

# Домашнее задание к занятию "7.1. Инфраструктура как код"

## Задача 1. Выбор инструментов.

<details>

### Легенда

Через час совещание, на котором менеджер расскажет о новом проекте. Начать работу над которым надо
будет уже сегодня.
На данный момент известно, что это будет сервис, который ваша компания будет предоставлять внешним заказчикам.
Первое время, скорее всего, будет один внешний клиент, со временем внешних клиентов станет больше.

Так же по разговорам в компании есть вероятность, что техническое задание еще не четкое, что приведет к большому
количеству небольших релизов, тестирований интеграций, откатов, доработок, то есть скучно не будет.

Вам, как девопс инженеру, будет необходимо принять решение об инструментах для организации инфраструктуры.
На данный момент в вашей компании уже используются следующие инструменты:

- остатки Сloud Formation,
- некоторые образы сделаны при помощи Packer,
- год назад начали активно использовать Terraform,
- разработчики привыкли использовать Docker,
- уже есть большая база Kubernetes конфигураций,
- для автоматизации процессов используется Teamcity,
- также есть совсем немного Ansible скриптов,
- и ряд bash скриптов для упрощения рутинных задач.

Для этого в рамках совещания надо будет выяснить подробности о проекте, что бы в итоге определиться с инструментами:

1. Какой тип инфраструктуры будем использовать для этого проекта: изменяемый или неизменяемый?

` Неизменяемый тип - immutable infrastructure`.

2. Будет ли центральный сервер для управления инфраструктурой?

` нет` `У Ansible, CloudFormation и Terraform по умолчанию нет центрального сервера.`

3. Будут ли агенты на серверах?
   ` нет` `Ansible, CloudFormation и Terraform по умолчанию не требуют предустановленных агентов.`

4. Будут ли использованы средства для управления конфигурацией или инициализации ресурсов
   `Terrraform для инициализации, Ansible для управления конфигурацией`

В связи с тем, что проект стартует уже сегодня, в рамках совещания надо будет определиться со всеми этими вопросами.

### В результате задачи необходимо

1. Ответить на четыре вопроса представленных в разделе "Легенда".
   (выше)
2. Какие инструменты из уже используемых вы хотели бы использовать для нового проекта?
   `Packer, Terraform, Docker, Kubernetes, Ansible`

3. Хотите ли рассмотреть возможность внедрения новых инструментов для этого проекта?

`Обязательно организовать мониторинг систем, чтобы в случае необходимости быстро устранять проблемы.
(Prometheus, Node Exporter и Grafana.)`


</details>

## Задача 2. Установка терраформ.

<details>
Официальный сайт: https://www.terraform.io/

Установите терраформ при помощи менеджера пакетов используемого в вашей операционной системе.
В виде результата этой задачи приложите вывод команды `terraform --version`.

## Ответ

```bash 
nik@ubuntuVM:~$ terraform version
Terraform v1.3.4
on linux_amd64
```

</details>

## Задача 3. Поддержка легаси кода.

<details>

В какой-то момент вы обновили терраформ до новой версии, например с 0.12 до 0.13.
А код одного из проектов настолько устарел, что не может работать с версией 0.13.
В связи с этим необходимо сделать так, чтобы вы могли одновременно использовать последнюю версию терраформа
установленную при помощи
штатного менеджера пакетов и устаревшую версию 0.12.

В виде результата этой задачи приложите вывод `--version` двух версий терраформа доступных на вашем компьютере
или виртуальной машине.

## Ответ

Для установки еще одной версии terraform выполним следующие дейcтвия:

- создадим директорию для хранения бинарного файла и перейдем в неё

```bash
nik@ubuntuVM:~$  mkdir -p /usr/local/tf/11
```

```bash
nik@ubuntuVM:~$ cd /usr/local/tf/11
```

- загрузим с официального репозитория архив `terraform` необходимой версии, распакуем его и удалим скачанный архив

```bash
nik@ubuntuVM:/usr/local/tf/11$ sudo wget https://releases.hashicorp.com/terraform/0.11.14/terraform_0.11.14_linux_amd64.zip
--2022-12-13 21:50:18--  https://releases.hashicorp.com/terraform/0.11.14/terraform_0.11.14_linux_amd64.zip
Resolving releases.hashicorp.com (releases.hashicorp.com)... 13.227.173.92, 13.227.173.121, 13.227.173.76, ...
Connecting to releases.hashicorp.com (releases.hashicorp.com)|13.227.173.92|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 12569267 (12M) [application/zip]
Saving to: ‘terraform_0.11.14_linux_amd64.zip.1’
terraform_0.11.14_linux_amd64.zip.1           100%[=================================================================================================>]  11,99M  6,91MB/s    in 1,7s    
2022-12-13 21:50:20 (6,91 MB/s) - ‘terraform_0.11.14_linux_amd64.zip’ saved [12569267/12569267]
```

```bash
nik@ubuntuVM:/usr/local/tf/11$ unzip terraform_0.11.14_linux_amd64.zip
Archive:  terraform_0.11.14_linux_amd64.zip
  inflating: terraform  
```

```bash
nik@ubuntuVM:/usr/local/tf/11$ rm terraform_0.11.14_linux_amd64.zip
```

- создадим символическую ссылку в `/usr/bin/` каталоге:

```bash
nik@ubuntuVM:/usr/local/tf/11$ sudo ln -s /usr/local/tf/11/terraform /usr/bin/terraform11
```

**Проверим доступные версии terraform:**

```bash
nik@ubuntuVM:~$ terraform version
Terraform v1.3.4
on linux_amd64

nik@ubuntuVM:~$ terraform11 version
Terraform v0.11.14
```

</details>

____

# Домашнее задание к занятию "7.2. Облачные провайдеры и синтаксис Terraform."

## Задача 1 (Вариант с Yandex.Cloud). Регистрация в ЯО и знакомство с основами (необязательно, но крайне желательно).

<details>

1. Подробная инструкция на русском языке
   содержится [здесь](https://cloud.yandex.ru/docs/solutions/infrastructure-management/terraform-quickstart).

2. Обратите внимание на период бесплатного использования после регистрации аккаунта.

3. Используйте раздел "Подготовьте облако к работе" для регистрации аккаунта. Далее раздел "Настройте провайдер" для
   подготовки
   базового терраформ конфига.

4. Воспользуйтесь [инструкцией](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs) на сайте
   терраформа, чтобы
   не указывать авторизационный токен в коде, а терраформ провайдер брал его из переменных окружений.

> Чтобы не указывать в явном виде в коде информацию о токенах и др., нужно задать переменные окружения:

```bash
  export YC_TOKEN="**********"
  export YC_CLOUD_ID="**********"
  export YC_FOLDER_ID="***********"
```

</details>

## Задача 2. Создание aws ec2 или yandex_compute_instance через терраформ.

<details>

1. В каталоге `terraform` вашего основного репозитория, который был создан в начале курсе, создайте файл `main.tf`
   и `versions.tf`.
2. Зарегистрируйте провайдер
    1. для [aws](https://registry.terraform.io/providers/hashicorp/aws/latest/docs). В файл `main.tf` добавьте
       блок `provider`, а в `versions.tf` блок `terraform` с вложенным блоком `required_providers`. Укажите любой
       выбранный вами регион
       внутри блока `provider`.
    2. либо для [yandex.cloud](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs). Подробную
       инструкцию можно найти
       [здесь](https://cloud.yandex.ru/docs/solutions/infrastructure-management/terraform-quickstart).
3. Внимание! В гит репозиторий нельзя пушить ваши личные ключи доступа к аккаунту. Поэтому в предыдущем задании мы
   указывали
   их в виде переменных окружения.
4. В файле `main.tf` воспользуйтесь блоком `data "aws_ami` для поиска ami образа последнего Ubuntu.
5. В файле `main.tf` создайте ресурс
    1. либо [ec2 instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance).
       Постарайтесь указать как можно больше параметров для его определения. Минимальный набор параметров указан в
       первом блоке
       `Example Usage`, но желательно, указать большее количество параметров.
    2.
   либо [yandex_compute_image](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_image)
   .
6. Также в случае использования aws:
    1. Добавьте data-блоки `aws_caller_identity` и `aws_region`.
    2. В файл `outputs.tf` поместить блоки `output` с данными об используемых в данный момент:
        * AWS account ID,
        * AWS user ID,
        * AWS регион, который используется в данный момент,
        * Приватный IP ec2 инстансы,
        * Идентификатор подсети в которой создан инстанс.
7. Если вы выполнили первый пункт, то добейтесь того, что бы команда `terraform plan` выполнялась без ошибок.

## Ответ

В качестве результата задания предоставьте:

1. Ответ на вопрос: при помощи какого инструмента (из разобранных на прошлом занятии) можно создать свой образ ami?

> Свой образ можно создать с
> помощью [Packer](https://cloud.yandex.ru/docs/tutorials/infrastructure-management/packer-custom-image).

2. Ссылку на [репозиторий](https://github.com/nikolay480/devops-netology/tree/main/terraform) с исходной конфигурацией
   терраформа.

</details>

___

# Домашнее задание к занятию "7.3. Основы и принцип работы Терраформ"

## Задача 1. Создадим бэкэнд в S3 (необязательно, но крайне желательно).

Если в рамках предыдущего задания у вас уже есть аккаунт AWS, то давайте продолжим знакомство со взаимодействием
терраформа и aws.

1. Создайте s3 бакет, iam роль и пользователя от которого будет работать терраформ. Можно создать отдельного
   пользователя,
   а можно использовать созданного в рамках предыдущего задания, просто добавьте ему необходимы права, как описано
   [здесь](https://www.terraform.io/docs/backends/types/s3.html).
1. Зарегистрируйте бэкэнд в терраформ проекте как описано по ссылке выше.

## Задача 2. Инициализируем проект и создаем воркспейсы.

1. Выполните `terraform init`:
    * если был создан бэкэнд в S3, то терраформ создат файл стейтов в S3 и запись в таблице
      dynamodb.
    * иначе будет создан локальный файл со стейтами.
1. Создайте два воркспейса `stage` и `prod`.
1. В уже созданный `aws_instance` добавьте зависимость типа инстанса от вокспейса, что бы в разных ворскспейсах
   использовались разные `instance_type`.
1. Добавим `count`. Для `stage` должен создаться один экземпляр `ec2`, а для `prod` два.
1. Создайте рядом еще один `aws_instance`, но теперь определите их количество при помощи `for_each`, а не `count`.
1. Что бы при изменении типа инстанса не возникло ситуации, когда не будет ни одного инстанса добавьте параметр
   жизненного цикла `create_before_destroy = true` в один из рессурсов `aws_instance`.
1. При желании поэкспериментируйте с другими параметрами и рессурсами.

В виде результата работы пришлите:

* Вывод команды `terraform workspace list`.
* Вывод команды `terraform plan` для воркспейса `prod`.

---