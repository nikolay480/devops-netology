# Домашнее задание к занятию «Хранение в K8s. Часть 2»

### Цель задания

В тестовой среде Kubernetes нужно создать PV и продемострировать запись и хранение файлов.

------

### Чеклист готовности к домашнему заданию

1. Установленное K8s-решение (например, MicroK8S).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключенным GitHub-репозиторием.

------

### Дополнительные материалы для выполнения задания

1. [Инструкция по установке NFS в MicroK8S](https://microk8s.io/docs/nfs). 
2. [Описание Persistent Volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/). 
3. [Описание динамического провижининга](https://kubernetes.io/docs/concepts/storage/dynamic-provisioning/). 
4. [Описание Multitool](https://github.com/wbitt/Network-MultiTool).

------

### Задание 1

**Что нужно сделать**

Создать Deployment приложения, использующего локальный PV, созданный вручную.

1. Создать Deployment приложения, состоящего из контейнеров busybox и multitool.
   
[deployment](./manifest/busybox-multitool-deployment.yaml)

2. Создать PV и PVC для подключения папки на локальной ноде, которая будет использована в поде.
   
[my-pv](./manifest/my-pv.yaml) 

[my-pvc](./manifest/my-pvc.yaml)

1. Продемонстрировать, что multitool может читать файл, в который busybox пишет каждые пять секунд в общей директории. 
   
```bash
root@nik-Ubuntu:/home/nik/devops-netology/kube-hw/13-kubeconfig-02-storage02/manifest# microk8s kubectl get pv
NAME    CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM            STORAGECLASS   REASON   AGE
my-pv   1Gi        RWO            Retain           Bound    default/my-pvc                           11m
root@nik-Ubuntu:/home/nik/devops-netology/kube-hw/13-kubeconfig-02-storage02/manifest# microk8s kubectl get pvc
NAME     STATUS   VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   AGE
my-pvc   Bound    my-pv    1Gi        RWO                           11m
root@nik-Ubuntu:/home/nik/devops-netology/kube-hw/13-kubeconfig-02-storage02/manifest# microk8s kubectl get pod
NAME                                            READY   STATUS    RESTARTS   AGE
busybox-multitool-deployment-575d5744b7-9hjl7   2/2     Running   0          11m
root@nik-Ubuntu:/home/nik/devops-netology/kube-hw/13-kubeconfig-02-storage02/manifest# microk8s kubectl exec -it busybox-multitool-deployment-575d5744b7-9hjl7 -c multitool -- bash
bash-5.1# cat /data/pv1/data.txt
Thu Jul 13 08:46:54 UTC 2023
Thu Jul 13 08:46:59 UTC 2023
Thu Jul 13 08:47:04 UTC 2023
Thu Jul 13 08:47:09 UTC 2023
Thu Jul 13 08:47:14 UTC 2023
Thu Jul 13 08:47:19 UTC 2023
Thu Jul 13 08:47:24 UTC 2023
Thu Jul 13 08:47:29 UTC 2023
Thu Jul 13 08:47:34 UTC 2023
Thu Jul 13 08:47:39 UTC 2023
Thu Jul 13 08:47:44 UTC 2023
Thu Jul 13 08:47:49 UTC 2023
Thu Jul 13 08:47:54 UTC 2023
Thu Jul 13 08:47:59 UTC 2023
Thu Jul 13 08:48:04 UTC 2023
Thu Jul 13 08:48:09 UTC 2023
Thu Jul 13 08:48:14 UTC 2023
Thu Jul 13 08:48:19 UTC 2023
Thu Jul 13 08:48:24 UTC 2023
Thu Jul 13 08:48:29 UTC 2023
Thu Jul 13 08:48:34 UTC 2023
```

4. Удалить Deployment и PVC. Продемонстрировать, что после этого произошло с PV. Пояснить, почему.

После удаления PVC, наш PV поменяет статус с Bound на Released, так как больше не свзан с PVC.

```bash
root@nik-Ubuntu:/home/nik/devops-netology/kube-hw/13-kubeconfig-02-storage02/manifest# ls /data/pv1
data.txt
root@nik-Ubuntu:/home/nik/devops-netology/kube-hw/13-kubeconfig-02-storage02/manifest# microk8s kubectl get pvc
NAME     STATUS   VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   AGE
my-pvc   Bound    my-pv    1Gi        RWO                           90s
root@nik-Ubuntu:/home/nik/devops-netology/kube-hw/13-kubeconfig-02-storage02/manifest# microk8s kubectl get pv
NAME    CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM            STORAGECLASS   REASON   AGE
my-pv   1Gi        RWO            Retain           Bound    default/my-pvc                           2m25s
root@nik-Ubuntu:/home/nik/devops-netology/kube-hw/13-kubeconfig-02-storage02/manifest# microk8s kubectl delete deploy busybox-multitool-deployment
deployment.apps "busybox-multitool-deployment" deleted
root@nik-Ubuntu:/home/nik/devops-netology/kube-hw/13-kubeconfig-02-storage02/manifest# microk8s kubectl delete pvc my-pvc
persistentvolumeclaim "my-pvc" deleted
root@nik-Ubuntu:/home/nik/devops-netology/kube-hw/13-kubeconfig-02-storage02/manifest# microk8s kubectl get pv
NAME    CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS     CLAIM            STORAGECLASS   REASON   AGE
my-pv   1Gi        RWO            Retain           Released   default/my-pvc                           4m56s
root@nik-Ubuntu:/home/nik/devops-netology/kube-hw/13-kubeconfig-02-storage02/manifest# ls /data/pv1/
data.txt
```

5. Продемонстрировать, что файл сохранился на локальном диске ноды. Удалить PV.  Продемонстрировать что произошло с файлом после удаления PV. Пояснить, почему.

Если удалить Persistent Volume с типом “retain”, то данные на этом томе будут сохранены. 

```bash
root@nik-Ubuntu:/home/nik/devops-netology/kube-hw/13-kubeconfig-02-storage02/manifest# microk8s kubectl delete pv my-pv
persistentvolume "my-pv" deleted
root@nik-Ubuntu:/home/nik/devops-netology/kube-hw/13-kubeconfig-02-storage02/manifest# ls /data/pv1
data.txt
root@nik-Ubuntu:/home/nik/devops-netology/kube-hw/13-kubeconfig-02-storage02/manifest#   
```

6. Предоставить манифесты, а также скриншоты или вывод необходимых команд.

------

### Задание 2

**Что нужно сделать**

Создать Deployment приложения, которое может хранить файлы на NFS с динамическим созданием PV.

1. Включить и настроить NFS-сервер на MicroK8S.
 
Включим аддон nfs: `microk8s enable nfs  `

Для создания своего NFS установим  и настроим его с помощью [ansible-playbook](./nfs-playbook/).

Установим provisioner CSI driver NFS:

```
nik@nik-Ubuntu:~$ microk8s kubectl get csidrivers
NAME             ATTACHREQUIRED   PODINFOONMOUNT   STORAGECAPACITY   TOKENREQUESTS   REQUIRESREPUBLISH   MODES        AGE
nfs.csi.k8s.io   false            false            false              <unset>         false               Persistent   9m43s
```



2. Создать Deployment приложения состоящего из multitool, и подключить к нему PV, созданный автоматически на сервере NFS.

Cоздадим `StorageClass` используя манифест [sc.yaml](./manifest/sc.yaml):

```bash
nik@nik-Ubuntu:~$ k get sc
NAME                          PROVISIONER                            RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
microk8s-hostpath (default)   microk8s.io/hostpath                   Delete          WaitForFirstConsumer   false                  177m
nfs-csi                       nfs.csi.k8s.io                         Delete          Immediate              false                  151m
nfs                           cluster.local/nfs-server-provisioner   Delete          Immediate              true                   146m
```

Создадим [my-pvc2](./manifest/my-pvc2.yaml) и [my-pvc3](./manifest/my-pvc3.yaml): 

```bash
nik@nik-Ubuntu:~$ k get pvc
NAME      STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
my-pvc3   Bound    pvc-25beb2f5-4363-4af7-ad45-0f3d63b079ae   300Mi      RWO            nfs-csi        36m
my-pvc2   Bound    pvc-c012ef7f-8bbf-4964-8860-696a3bb8d531   500Mi      RWO            nfs            36m
```

Для запуска деплоймента используем манифест [multitool](./manifest/multitool-deployment-pvc.yaml):
```bash
nik@nik-Ubuntu:~$ k get deployments.apps 
NAME                   READY   UP-TO-DATE   AVAILABLE   AGE
multitool-deployment   1/1     1            1           141m
```

3. Продемонстрировать возможность чтения и записи файла изнутри пода.
```bash
nik@nik-Ubuntu:~/devops-netology/kube-hw/13-kubeconfig-02-storage02/manifest$ k apply -f multitool-deployment-2pvc.yaml 
deployment.apps/multitool-deployment created
persistentvolumeclaim/my-pvc2 created
nik@nik-Ubuntu:~/devops-netology/kube-hw/13-kubeconfig-02-storage02/manifest$ k get sc
NAME                          PROVISIONER                            RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
microk8s-hostpath (default)   microk8s.io/hostpath                   Delete          WaitForFirstConsumer   false                  4d
nfs-csi                       nfs.csi.k8s.io                         Delete          Immediate              false                  5h12m
nfs                           cluster.local/nfs-server-provisioner   Delete          Immediate              true                   31m
nik@nik-Ubuntu:~/devops-netology/kube-hw/13-kubeconfig-02-storage02/manifest$ k exec -it multitool-deployment-77f45d6995-7xgwf -- bash
bash-5.1# cd /share-data/
bash-5.1# ls -la
total 8
drwxrwsrwx    2 root     root          4096 Jul 13 18:10 .
drwxr-xr-x    1 root     root          4096 Jul 13 18:10 ..
bash-5.1# echo "netology test text" > test1.txt
bash-5.1# cat test1.txt 
netology test text
bash-5.1# 
exit
nik@nik-Ubuntu:~/devops-netology/kube-hw/13-kubeconfig-02-storage02/manifest$ cat /var/snap/microk8s/common/nfs-storage/pvc-75ad253c-d4ee-441e-acdf-246912dd314a/test1.txt 
netology test text
nik@nik-Ubuntu:~/devops-netology/kube-hw/13-kubeconfig-02-storage02/manifest$ echo "second test file for netology" > /var/snap/microk8s/common/nfs-storage/pvc-75ad253c-d4ee-441e-acdf-246912dd314a/test2.txt
nik@nik-Ubuntu:~/devops-netology/kube-hw/13-kubeconfig-02-storage02/manifest$  k exec -it multitool-deployment-77f45d6995-7xgwf -- bash
bash-5.1# ls /share-data/
test1.txt  test2.txt
bash-5.1# cat /share-data/test2.txt 
second test file for netology
```

Теперь проверим  возможность записи и чтения файлов на созданном NFS, записав файл в каталог:

```bash
bash-5.1# echo test-nfssci > /nfscsi-data/nfs.txt 
bash-5.1# cat /nfscsi-data/nfs.txt 
test-nfssci
```

Подключимся к серверу с установленным NFS:
```bash
nik@nik-Ubuntu:~$ ssh ubuntu@51.250.67.190
```
Убедимся, что созданный файл nfs.txt существует на сервере:
```bash
ubuntu@fhmpvrqtrs9s9rlaoprs:~$ cd /nfs/data
ubuntu@fhmpvrqtrs9s9rlaoprs:/nfs/data$ ls -la
total 24
drwxrwxrwx 6 root root 4096 Jul 16 15:49 .
drwxrwxrwx 3 root root 4096 Jul 14 17:46 ..
drwxrwxrwx 2 root root 4096 Jul 14 17:46 minio
drwxrwxrwx 2 root root 4096 Jul 14 17:46 mysql
drwxr-xr-x 2 root root 4096 Jul 16 16:17 pvc-25beb2f5-4363-4af7-ad45-0f3d63b079ae
drwxr-xr-x 2 root root 4096 Jul 14 18:49 pvc-d0f4125d-ec0d-4261-9f68-aaa16b8846f7
ubuntu@fhmpvrqtrs9s9rlaoprs:/nfs/data$ cd pvc-25beb2f5-4363-4af7-ad45-0f3d63b079ae/
ubuntu@fhmpvrqtrs9s9rlaoprs:/nfs/data/pvc-25beb2f5-4363-4af7-ad45-0f3d63b079ae$ ls -la
total 12
drwxr-xr-x 2 root root 4096 Jul 16 16:17 .
drwxrwxrwx 6 root root 4096 Jul 16 15:49 ..
-rw-r--r-- 1 root root   12 Jul 16 16:17 nfs.txt
ubuntu@fhmpvrqtrs9s9rlaoprs:/nfs/data/pvc-25beb2f5-4363-4af7-ad45-0f3d63b079ae$ cat nfs.txt 
test-nfssci
```

3. Предоставить манифесты, а также скриншоты или вывод необходимых команд.

------

### Правила приёма работы

1. Домашняя работа оформляется в своём Git-репозитории в файле README.md. Выполненное задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl`, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.