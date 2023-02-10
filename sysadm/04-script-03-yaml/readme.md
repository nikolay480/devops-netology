# Домашнее задание к занятию "4.3. Языки разметки JSON и YAML"

## Обязательные задания

1. Мы выгрузили JSON, который получили через API запрос к нашему сервису:

```
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            },
            { "name" : "second",
            "type" : "proxy",
            "ip : 71.78.22.43
            }
        ]
    }
```

Нужно найти и исправить все ошибки, которые допускает наш сервис

```json
{
  "info": "Sample JSON output from our service",
  "elements": [
    {
      "name": "first",
      "type": "server",
      "ip": "7.1.7.5"
    },
    {
      "name": "second",
      "type": "proxy",
      "ip": "71.78.22.43"
    }
  ]
}
```

2. В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному
   функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по
   одному сервису: { "имя сервиса" : "его IP"}. Формат записи YAML по одному сервису: - имя сервиса: его IP. Если в
   момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.

```python
#!/bin/python3
import socket
import json
import yaml

with open ("ip.json", "r") as j_file:
    servers = json.load(j_file)

    for host, ip in servers.items():
        new_ip = socket.gethostbyname(host)
        if (ip != new_ip):
            print ('[ERROR] {} IP mismatch: {} {}'.format(host,ip,new_ip))
            servers[host] = new_ip

    for host, ip in servers.items():
        print(f'{host} - {ip}')

with open("ip.json", "w") as j_file:
    json.dump(servers, j_file, indent=2)

with open("ip.yaml", "w") as y_file:
    y_file.write(yaml.dump(servers,explicit_start=True, explicit_end=True))
```

Результат работы скрипта:
```bash
nik@HOME-PC:~$ ./pyt_scr.py
[ERROR] drive.google.com IP mismatch: 0.0.0.0 142.250.185.206
[ERROR] mail.google.com IP mismatch: 0.0.0.0 142.250.184.229
[ERROR] google.com IP mismatch: 0.0.0.0 142.250.186.142
drive.google.com - 142.250.185.206
mail.google.com - 142.250.184.229
google.com - 142.250.186.142
nik@HOME-PC:~$ cat ip.json
{
  "drive.google.com": "142.250.185.206",
  "mail.google.com": "142.250.184.229",
  "google.com": "142.250.186.142"
}nik@HOME-PC:~$ cat ip.yaml
---
drive.google.com: 142.250.185.206
google.com: 142.250.186.142
mail.google.com: 142.250.184.229
---
```