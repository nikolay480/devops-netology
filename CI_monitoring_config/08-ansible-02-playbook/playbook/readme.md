# Clickhouse & Vector

[Playbook](./) состоит из `2 play: clickhouse и Vector`, каждому из которых присвоены одноименные `hosts` и `tags`.

В каждом play свои задачи `(tasks)`. В основном - скачивание установочного пакета, установка с помощью пакетного
менеджера, перезапуск демона.

В [group_vars](./group_vars) описаны переменные и их значения, которые потом подставляются в плейбук в двойных фигурных
скобках `{{ }}`.

```yaml
--
clickhouse_version: "22.3.3.44"
clickhouse_packages:
  - clickhouse-client
  - clickhouse-server
  - clickhouse-common-static

arch: "x86_64"
```

В файлe [vector.yaml](./config_vector/vector.yaml) описана конфигурация для Vector.
Используя модуль `COPY` файл копируется с `control node` на `managed node`

```yaml
   - name: Copy config
       become: true
       ansible.builtin.copy:
         src: ./vector_config/vector.yaml
         dest: /etc/vector/vector.yaml
         owner: root
         group: root
         mode: '775'
```

При запуске необходимо указать данный файл конфигурации

```bash
root@fhmd4smvrk5q5ielic8b centos]# vector --config /etc/vector/vector.yaml
2023-02-04T17:17:44.524146Z  INFO vector::app: Internal log rate limit configured. internal_log_rate_secs=10
2023-02-04T17:17:44.524376Z  INFO vector::app: Log level is enabled. level="vector=info,codec=info,vrl=info,file_source=info,tower_limit=trace,rdkafka=info,buffers=info,lapin=info,kube=info"
2023-02-04T17:17:44.524726Z  INFO vector::app: Loading configs. paths=["/etc/vector/vector.yaml"]
2023-02-04T17:17:44.550035Z  INFO vector::topology::running: Running healthchecks.
2023-02-04T17:17:44.550297Z  INFO vector: Vector has started. debug="false" version="0.27.0" arch="x86_64" revision="5623d1e 2023-01-18"
2023-02-04T17:17:44.550345Z  INFO vector::app: API is disabled, enable by setting `api.enabled` to `true` and use commands like `vector top`.
2023-02-04T17:17:44.550720Z  INFO source{component_kind="source" component_id=my_source component_type=file component_name=my_source}: vector::sources::file: Starting file server. include=["/var/log/yum.log"] exclude=[]
2023-02-04T17:17:44.551336Z  INFO source{component_kind="source" component_id=my_source component_type=file component_name=my_source}:file_server: file_source::checkpointer: Loaded checkpoint data.
2023-02-04T17:17:44.551952Z  WARN http: vector::internal_events::http_client: HTTP error. error=error trying to connect: tcp connect error: Connection refused (os error 111) error_type="request_failed" stage="processing" internal_log_rate_limit=true
2023-02-04T17:17:44.552037Z ERROR vector::topology::builder: msg="Healthcheck failed." error=Failed to make HTTP(S) request: error trying to connect: tcp connect error: Connection refused (os error 111) component_kind="sink" component_type="clickhouse" component_id=my_sink component_name=my_sink
2023-02-04T17:17:44.552187Z  INFO source{component_kind="source" component_id=my_source component_type=file component_name=my_source}:file_server: vector::internal_events::file::source: Found new file to watch. file=/var/log/yum.log
```



