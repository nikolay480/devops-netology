# Домашнее задание к занятию «Микросервисы: принципы»

Вы работаете в крупной компании, которая строит систему на основе микросервисной архитектуры.
Вам как DevOps-специалисту необходимо выдвинуть предложение по организации инфраструктуры для разработки и эксплуатации.

## Задача 1: API Gateway 

Предложите решение для обеспечения реализации API Gateway. Составьте сравнительную таблицу возможностей различных программных решений. На основе таблицы сделайте выбор решения.

Решение должно соответствовать следующим требованиям:
- маршрутизация запросов к нужному сервису на основе конфигурации,
- возможность проверки аутентификационной информации в запросах,
- обеспечение терминации HTTPS.

Обоснуйте свой выбор.

### Ответ

| Решение | Маршрутизация запросов | Аутентификация при запросах | Терминация HTTPS |
|:---:|:---:|:---:|:---:|
| Kong   | ✔ | ✔ | ✔ |
| APIGee | ✔ | ✔ | ✔ |
| Express Gateway | ✔ | ✔ | ✔ |
| Axway | ✔ | ✔ | ✔ |
| Tyk | ✔ | ✔ | ✔ |
| Amazon| ✔ | ✔ | ✔ |
| NGINX Plus | ✔ | ✔ | ✔ |


На рынке существует два вида различных поставщиков API-шлюзов, каждый со своими уникальными функциями и возможностями - Open-source API Gateways и Proprietary API Gateways.

API с открытым исходным кодом создаются и поддерживаются сообществом разработчиков, и каждый может получить к ним доступ и использовать их. Это делает их популярным выбором для разработчиков, которые хотят создавать новые приложения или интеграции.

Проприетарный API-шлюз - это коммерческий продукт, который  можно купить и установить. Проприетарные API-шлюзы имеют ряд преимуществ перед другими типами API-шлюзов.

Обычно их проще настраивать, и они часто поставляются с множеством дополнительных функций, таких как аналитика и документация.

Выбор решения во многом будет зависеть от компании, готова ли она платить или использует бесплатные решения. Также зависит от конфигуации обрудования. При использованиии  комерческих облачных решений можно порекомендовать использовать такие продукты, как Amazon API Gateway или Azure API Gateway.

Среди open-source решений наиболее популярным можно назвать Kong, который отличается высокой производительностью, расширяемостью и переносимостью. Kong также легкий, быстрый и масштабируемый. Он поддерживает декларативную конфигурацию без базы данных, используя только хранилище в памяти и собственные Kubernative CRDS.

Также можно порекомендовать Tyk. Это мощный, легкий и полнофункциональный API-шлюз с открытым исходным кодом, написанный с нуля с использованием языка программирования Go. Это облачный интерфейс с высокой производительностью и легко расширяемой и подключаемой архитектурой, основанной на открытых стандартах.
Tyk обладает множеством функций, которые включают в себя различные методы аутентификации, квоты и ограничение скорости, контроль версий, уведомления и события, мониторинг и аналитику. Он также поддерживает обнаружение служб, преобразования "на лету" и виртуальные конечные точки, а также позволяет создавать макеты API перед выпуском.

Помимо всего вышеперечисленного, Tyk поддерживает документацию по API и предлагает портал разработчика API, систему, подобную CMS (системе управления контентом), где вы можете публиковать свои управляемые API, а сторонние разработчики регистрируются, подключаются к вашим API и могут управлять своими собственными ключами.



## Задача 2: Брокер сообщений

Составьте таблицу возможностей различных брокеров сообщений. На основе таблицы сделайте обоснованный выбор решения.

Решение должно соответствовать следующим требованиям:
- поддержка кластеризации для обеспечения надёжности,
- хранение сообщений на диске в процессе доставки,
- высокая скорость работы,
- поддержка различных форматов сообщений,
- разделение прав доступа к различным потокам сообщений,
- простота эксплуатации.

Обоснуйте свой выбор.

### Ответ 

| Broker| Clustering | Disk Message Storage | High Throughput | Message Formats | Access Control| Easy of Use |
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
|Apache ActiveMQ|✔|✔|✔|Many, including JMS, AMQP, MQTT|✔|Medium|
|RabbitMQ|✔|✔|✔|Many, including AMQP, MQTT, STOMP|✔|Medium|
|Apache Kafka|✔|✔|✔|JSON, Avro, Protobuf|No (requires external authentication)|Medium|
|Amazon SQS|✔|✔|✔|Simple Text|✔|Easy|
|Google Cloud Pub/Sub|✔|✔|✔|Binary, Text, JSON|✔|Easy|

Основываясь на этих параметрах, Apache ActiveMQ, RabbitMQ и Apache Kafka отвечают всем основным требованиям, но Apache ActiveMQ и RabbitMQ более гибкие с точки зрения форматов сообщений и контроля доступа. Amazon SQS и Google Cloud Pub/Sub очень просты в использовании, но не столь гибки с точки зрения форматов сообщений и контроля доступа, как другие опции. Наиболее подходящий вариант для конкретного случая использования в конечном счете зависит от конкретных потребностей и ограничений проекта.

## Задача 3: API Gateway * (необязательная)

### Есть три сервиса:

**minio**
- хранит загруженные файлы в бакете images,
- S3 протокол,

**uploader**
- принимает файл, если картинка сжимает и загружает его в minio,
- POST /v1/upload,

**security**
- регистрация пользователя POST /v1/user,
- получение информации о пользователе GET /v1/user,
- логин пользователя POST /v1/token,
- проверка токена GET /v1/token/validation.

### Необходимо воспользоваться любым балансировщиком и сделать API Gateway:

**POST /v1/register**
1. Анонимный доступ.
2. Запрос направляется в сервис security POST /v1/user.

**POST /v1/token**
1. Анонимный доступ.
2. Запрос направляется в сервис security POST /v1/token.

**GET /v1/user**
1. Проверка токена. Токен ожидается в заголовке Authorization. Токен проверяется через вызов сервиса security GET /v1/token/validation/.
2. Запрос направляется в сервис security GET /v1/user.

**POST /v1/upload**
1. Проверка токена. Токен ожидается в заголовке Authorization. Токен проверяется через вызов сервиса security GET /v1/token/validation/.
2. Запрос направляется в сервис uploader POST /v1/upload.

**GET /v1/user/{image}**
1. Проверка токена. Токен ожидается в заголовке Authorization. Токен проверяется через вызов сервиса security GET /v1/token/validation/.
2. Запрос направляется в сервис minio GET /images/{image}.

### Ожидаемый результат

Результатом выполнения задачи должен быть docker compose файл, запустив который можно локально выполнить следующие команды с успешным результатом.
Предполагается, что для реализации API Gateway будет написан конфиг для NGinx или другого балансировщика нагрузки, который будет запущен как сервис через docker-compose и будет обеспечивать балансировку и проверку аутентификации входящих запросов.
Авторизация
curl -X POST -H 'Content-Type: application/json' -d '{"login":"bob", "password":"qwe123"}' http://localhost/token

**Загрузка файла**

curl -X POST -H 'Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJib2IifQ.hiMVLmssoTsy1MqbmIoviDeFPvo-nCd92d4UFiN2O2I' -H 'Content-Type: octet/stream' --data-binary @yourfilename.jpg http://localhost/upload

**Получение файла**
curl -X GET http://localhost/images/4e6df220-295e-4231-82bc-45e4b1484430.jpg

---

#### [Дополнительные материалы: как запускать, как тестировать, как проверить](https://github.com/netology-code/devkub-homeworks/tree/main/11-microservices-02-principles)

---