# Домашнее задание к занятию «Helm»

### Цель задания

В тестовой среде Kubernetes необходимо установить и обновить приложения с помощью Helm.

------

### Чеклист готовности к домашнему заданию

1. Установленное k8s-решение, например, MicroK8S.
2. Установленный локальный kubectl.
3. Установленный локальный Helm.
4. Редактор YAML-файлов с подключенным репозиторием GitHub.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Инструкция](https://helm.sh/docs/intro/install/) по установке Helm. [Helm completion](https://helm.sh/docs/helm/helm_completion/).

------

### Задание 1. Подготовить Helm-чарт для приложения

1. Необходимо упаковать приложение в чарт для деплоя в разные окружения. 
2. Каждый компонент приложения деплоится отдельным deployment’ом или statefulset’ом.
3. В переменных чарта измените образ приложения для изменения версии.

### Ответ

Cоздал чарт [my-nginx](./my-nginx/).

Для упаковки в архив можно воспользоваться командой `helm package`. Получим файл  [my-nginx-0.1.2.tgz](./my-nginx-0.1.2.tgz).

Для запуска в различные окружения созданы файлы [values-prod.yaml](./my-nginx/values-prod.yaml) и [values-test.yaml](./my-nginx/values-test.yaml). Значения по умолчанию записаны в [values.yaml](./my-nginx/values.yaml).

Выполним проверку чарта Helm на наличие потенциальных проблем или ошибок:

```bash
nik@nik-Ubuntu:~/devops-netology/kube-hw/13-kubconfig-05-helm$ helm lint my-nginx
==> Linting my-nginx
[INFO] Chart.yaml: icon is recommended

1 chart(s) linted, 0 chart(s) failed
```

------
### Задание 2. Запустить две версии в разных неймспейсах

1. Подготовив чарт, необходимо его проверить. Запуститe несколько копий приложения.
2. Одну версию в namespace=app1, вторую версию в том же неймспейсе, третью версию в namespace=app2.
3. Продемонстрируйте результат.

### Ответ

Cоздадим 2 неймспейча app1 и app2:

```bash
nik@nik-Ubuntu:~/devops-netology/kube-hw/13-kubconfig-05-helm$ k get ns | grep app
app1              Active   26h
app2              Active   26h
```

Запустим 3 копии приложений, произвольно изменяя верисю чарта или приложения:
```bash
nik@nik-Ubuntu:~/devops-netology/kube-hw/13-kubconfig-05-helm$ helm install webapp-01  my-nginx --values ./my-nginx/values-prod.yaml  -n app1
NAME: webapp-01
LAST DEPLOYED: Wed Jul 26 19:19:24 2023
NAMESPACE: app1
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
Content of NOTES.txt appears after deploy.
Deployed version 1.19.10.
nik@nik-Ubuntu:~/devops-netology/kube-hw/13-kubconfig-05-helm$ helm install webapp-02  my-nginx --values ./my-nginx/values-prod.yaml  -n app1
NAME: webapp-02
LAST DEPLOYED: Wed Jul 26 19:20:15 2023
NAMESPACE: app1
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
Content of NOTES.txt appears after deploy.
Deployed version 1.20.1.
nik@nik-Ubuntu:~/devops-netology/kube-hw/13-kubconfig-05-helm$ helm install webapp-03  my-nginx --values ./my-nginx/values-prod.yaml  -n app2
NAME: webapp-03
LAST DEPLOYED: Wed Jul 26 19:21:20 2023
NAMESPACE: app2
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
Content of NOTES.txt appears after deploy.
Deployed version 1.20.2.
```

Проверим список установленных `releases`:

```bash
nik@nik-Ubuntu:~/devops-netology/kube-hw/13-kubconfig-05-helm$ helm list -A
NAME            NAMESPACE       REVISION        UPDATED                                 STATUS          CHART                   APP VERSION
csi-driver-nfs  kube-system     1               2023-07-16 20:26:47.193510662 +0500 +05 deployed        csi-driver-nfs-v4.4.0   v4.4.0     
webapp-01       app1            1               2023-07-26 19:19:24.027980987 +0500 +05 deployed        my-nginx-0.1.1          1.19.10    
webapp-02       app1            1               2023-07-26 19:20:15.287334928 +0500 +05 deployed        my-nginx-0.1.2          1.20.1     
webapp-03       app2            1               2023-07-26 19:21:20.275781339 +0500 +05 deployed        my-nginx-0.1.2          1.20.2     
```

ПОсмотрим запущенные ресурсы:

```bash
nik@nik-Ubuntu:~/devops-netology/kube-hw/13-kubconfig-05-helm$ k get all -n app1
NAME                                        READY   STATUS    RESTARTS   AGE
pod/webapp-01-deployment-cb5bc966c-h5xhk    1/1     Running   0          5m54s
pod/webapp-01-deployment-cb5bc966c-cq9mv    1/1     Running   0          5m54s
pod/webapp-02-deployment-7978f789c7-bcx8d   1/1     Running   0          5m3s
pod/webapp-02-deployment-7978f789c7-kg7qr   1/1     Running   0          5m3s

NAME                    TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
service/webapp-01-svc   ClusterIP   10.152.183.29    <none>        80/TCP    5m54s
service/webapp-02-svc   ClusterIP   10.152.183.183   <none>        80/TCP    5m3s

NAME                                   READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/webapp-01-deployment   2/2     2            2           5m54s
deployment.apps/webapp-02-deployment   2/2     2            2           5m3s

NAME                                              DESIRED   CURRENT   READY   AGE
replicaset.apps/webapp-01-deployment-cb5bc966c    2         2         2       5m54s
replicaset.apps/webapp-02-deployment-7978f789c7   2         2         2       5m3s

nik@nik-Ubuntu:~/devops-netology/kube-hw/13-kubconfig-05-helm$ k get all -n app2
NAME                                       READY   STATUS    RESTARTS   AGE
pod/webapp-03-deployment-f5f7f4694-nrnnb   1/1     Running   0          4m17s
pod/webapp-03-deployment-f5f7f4694-tk5xl   1/1     Running   0          4m17s

NAME                    TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
service/webapp-03-svc   ClusterIP   10.152.183.184   <none>        80/TCP    4m17s

NAME                                   READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/webapp-03-deployment   2/2     2            2           4m17s

NAME                                             DESIRED   CURRENT   READY   AGE
replicaset.apps/webapp-03-deployment-f5f7f4694   2         2         2       4m17s
```

### Правила приёма работы

1. Домашняя работа оформляется в своём Git репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl`, `helm`, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.
