# Домашнее задание к занятию «Управление доступом»

### Цель задания

В тестовой среде Kubernetes нужно предоставить ограниченный доступ пользователю.

------

### Чеклист готовности к домашнему заданию

1. Установлено k8s-решение, например MicroK8S.
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключённым github-репозиторием.

------

### Инструменты / дополнительные материалы, которые пригодятся для выполнения задания

1. [Описание](https://kubernetes.io/docs/reference/access-authn-authz/rbac/) RBAC.
2. [Пользователи и авторизация RBAC в Kubernetes](https://habr.com/ru/company/flant/blog/470503/).
3. [RBAC with Kubernetes in Minikube](https://medium.com/@HoussemDellai/rbac-with-kubernetes-in-minikube-4deed658ea7b).

------

### Задание 1. Создайте конфигурацию для подключения пользователя

1. Создайте и подпишите SSL-сертификат для подключения к кластеру.


Создадим закрытый ключ:

```
openssl genrsa -out student.key 2048
```
Создадим запрос на подпись сертификата (certificate signing request, CSR). CN — имя пользователя:

```
openssl req -new -key student.key -out student.csr -subj "/CN=student"
```

Подпишем CSR в Kubernetes CA. Мы должны использовать сертификат CA и ключ, которые обычно находятся в /etc/kubernetes/pki. При использовании `microk8s` они размещаются в `/var/snap/microk8s/current/certs`. Сертификат будет действителен в течение 500 дней:

```
nik@nik-Ubuntu:~/devops-netology/kube-hw/13-kubconfig-04-rbac$ openssl x509 -req -in student.csr -CA /var/snap/microk8s/current/certs/ca.crt -CAkey /var/snap/microk8s/current/certs/ca.key -CAcreateserial -out student.crt -days 500
Certificate request self-signature ok
subject=CN = student
```

2. Настройте конфигурационный файл kubectl для подключения.

Создадим учетные данные для пользователя `student`:

```bash
nik@nik-Ubuntu:~/devops-netology/kube-hw/13-kubconfig-04-rbac$ microk8s kubectl config set-credentials student --client-certificate=./student.crt --client-key=./student.key
User "student" set.
```

Создадим контекст для пользователя `student` в кластере `microk8s-cluster`:

```bash
nik@nik-Ubuntu:~/devops-netology/kube-hw/13-kubconfig-04-rbac$  microk8s kubectl config set-context student-context --cluster=microk8s-cluster --user=student
Context "student-context" created.
```

Убедимся, что контекст создан и переключимся на него:

```bash
nik@nik-Ubuntu:~$ microk8s kubectl config get-contexts
CURRENT   NAME              CLUSTER            AUTHINFO   NAMESPACE
*         microk8s          microk8s-cluster   admin      
          student-context   microk8s-cluster   student    

nik@nik-Ubuntu:~$ microk8s kubectl config use-context student-context 
Switched to context "student-context".

nik@nik-Ubuntu:~$ microk8s kubectl config get-contexts
CURRENT   NAME              CLUSTER            AUTHINFO   NAMESPACE
          microk8s          microk8s-cluster   admin      
*         student-context   microk8s-cluster   student    
```

Просмотрим config:

```bash
nik@nik-Ubuntu:~$ microk8s kubectl config view
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: DATA+OMITTED
    server: https://127.0.0.1:16443
  name: microk8s-cluster
contexts:
- context:
    cluster: microk8s-cluster
    user: admin
  name: microk8s
- context:
    cluster: microk8s-cluster
    user: student
  name: student-context
current-context: student-context
kind: Config
preferences: {}
users:
- name: admin
  user:
    token: REDACTED
```

3. Создайте роли и все необходимые настройки для пользователя.
   
Создадим  [Role](./manifest/student-role.yaml) и [Rolebinding](./manifest/student-rolebinding.yaml):

```bash
nik@nik-Ubuntu:~/devops-netology/kube-hw/13-kubconfig-04-rbac$ k get roles.rbac.authorization.k8s.io  -n netology
NAME           CREATED AT
student-role   2023-07-20T16:03:29Z
nik@nik-Ubuntu:~/devops-netology/kube-hw/13-kubconfig-04-rbac$ k get rolebindings.rbac.authorization.k8s.io -n netology
NAME                  ROLE                AGE
student-rolebinding   Role/student-role   117m
```

4. Предусмотрите права пользователя. Пользователь может просматривать логи подов и их конфигурацию (`kubectl logs pod <pod_id>`, `kubectl describe pod <pod_id>`).



В пространстве имен `netology` запустим pod [hello-world](./manifest/hello-world.yaml):

```bash
nik@nik-Ubuntu:~/devops-netology/kube-hw/13-kubconfig-04-rbac$ microk8s kubectl get pods -n netology
NAME          READY   STATUS    RESTARTS   AGE
hello-world   1/1     Running   0          37s
```

Проверим, что права пользователя позволяют выполнить предусмотренные права:

```bash
nik@nik-Ubuntu:~/devops-netology/kube-hw/13-kubconfig-04-rbac$ microk8s kubectl describe pod hello-world -n netology
Name:             hello-world
Namespace:        netology
Priority:         0
Service Account:  default
Node:             nik-ubuntu/192.168.1.12
Start Time:       Thu, 20 Jul 2023 21:00:07 +0500
Labels:           <none>
Annotations:      cni.projectcalico.org/containerID: c39ef70b9829821652e4329c943f962ebe0d5d1c1de883fd809ae6da2ac32950
                  cni.projectcalico.org/podIP: 10.1.255.168/32
                  cni.projectcalico.org/podIPs: 10.1.255.168/32
Status:           Running
IP:               10.1.255.168
IPs:
  IP:  10.1.255.168
Containers:
  echoserver:
    Container ID:   containerd://4f715d7823b5cdcee2e5150eec5c42407cabd6d494981071903484455a9a9f72
    Image:          gcr.io/kubernetes-e2e-test-images/echoserver:2.2
    Image ID:       gcr.io/kubernetes-e2e-test-images/echoserver@sha256:e9ba514b896cdf559eef8788b66c2c3ee55f3572df617647b4b0d8b6bf81cf19
    Port:           8080/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Thu, 20 Jul 2023 21:00:08 +0500
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-pqc5c (ro)
Conditions:
  Type              Status
  Initialized       True 
  Ready             True 
  ContainersReady   True 
  PodScheduled      True 
Volumes:
  kube-api-access-pqc5c:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:                      <none>
```

```bash
nik@nik-Ubuntu:~/devops-netology/kube-hw/13-kubconfig-04-rbac$ microk8s kubectl logs hello-world -n netology
Generating self-signed cert
Generating a 2048 bit RSA private key
.........................+++
........+++
writing new private key to '/certs/privateKey.key'
-----

Starting nginx
```

Кроме того, можно увидеть, что неразрешенная команда выполняться не будет:
```bash
nik@nik-Ubuntu:~/devops-netology/kube-hw/13-kubconfig-04-rbac$ microk8s kubectl get node
Error from server (Forbidden): nodes is forbidden: User "student" cannot list resource "nodes" in API group "" at the cluster scope
```


------
