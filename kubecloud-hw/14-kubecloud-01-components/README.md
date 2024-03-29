# Домашнее задание к занятию «Компоненты Kubernetes»

### Цель задания

Рассчитать требования к кластеру под проект

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания:

- [Considerations for large clusters](https://kubernetes.io/docs/setup/best-practices/cluster-large/),
- [Architecting Kubernetes clusters — choosing a worker node size](https://learnk8s.io/kubernetes-node-size).

------

### Задание. Необходимо определить требуемые ресурсы
Известно, что проекту нужны база данных, система кеширования, а само приложение состоит из бекенда и фронтенда. Опишите, какие ресурсы нужны, если известно:

1. Необходимо упаковать приложение в чарт для деплоя в разные окружения. 
2. База данных должна быть отказоустойчивой. Потребляет 4 ГБ ОЗУ в работе, 1 ядро. 3 копии. 
3. Кеш должен быть отказоустойчивый. Потребляет 4 ГБ ОЗУ в работе, 1 ядро. 3 копии. 
4. Фронтенд обрабатывает внешние запросы быстро, отдавая статику. Потребляет не более 50 МБ ОЗУ на каждый экземпляр, 0.2 ядра. 5 копий. 
5. Бекенд потребляет 600 МБ ОЗУ и по 1 ядру на копию. 10 копий.

----

### Правила приёма работы

1. Домашняя работа оформляется в своем Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Сначала сделайте расчёт всех необходимых ресурсов.
3. Затем прикиньте количество рабочих нод, которые справятся с такой нагрузкой.
4. Добавьте к полученным цифрам запас, который учитывает выход из строя как минимум одной ноды. 
5. Добавьте служебные ресурсы к нодам. Помните, что для разных типов нод требовния к ресурсам разные. 
6. В результате должно быть указано количество нод и их параметры.
---
### Ответ

Для расчета необходимых ресурсов, мы должны учесть следующее:

**База данных:**

- Потребление ресурсов: 4 ГБ ОЗУ, 1 ядро
- Количество копий базы данных: 3
- Итоговое потребление ресурсов: 12 ГБ ОЗУ, 3 ядра

**Система кеширования:**

- Потребление ресурсов: 4 ГБ ОЗУ, 1 ядро
- Количество копий системы кеширования: 3
- Итоговое потребление ресурсов: 12 ГБ ОЗУ, 3 ядра

**Фронтенд:**

- Потребление ресурсов на один экземпляр: 50 МБ ОЗУ, 0.2 ядра
- Количество экземпляров фронтенда: 5
- Итоговое потребление ресурсов: 250 МБ ОЗУ, 1 ядро

**Бекенд:**

- Потребление ресурсов на одну копию: 600 МБ ОЗУ, 1 ядро
- Количество копий бекенда: 10
- Итоговое потребление ресурсов: 6 ГБ ОЗУ, 10 ядер


Теперь рассчитаем количество рабочих нод, которые справятся с нагрузкой:

**Итоговое потребление ресурсов:**

* ОЗУ: 12 ГБ (база данных) + 12 ГБ (система кеширования) + 250 МБ (фронтенд) + 6 ГБ (бекенд) = 30.25 ГБ
* Ядра: 3 ядра (база данных) + 3 ядра (система кеширования) + 1 ядро (фронтенд) + 10 ядер (бекенд) = 17 ядер

**Учитывая запас на случай выхода из строя одной ноды, можно использовать следующую конфигурацию нод:**

**Worker nodes:**
- *3 ноды по 12 ГБ ОЗУ и 4 ядра CPU* (используя pod affinity/antiaffinity определим данные ноды для  базы данных и системы кеширования)
- *5 нод по 2 ГБ ОЗУ и 4 ядра CPU* (аналогично определим для  frontend и backend)

**Master nodes (control plane):**

Для обеспечени отказоустойчивости и учитывая небольшую нагрузку будем считать, что потребуется **3 ноды** в минимальной конфигурации  **2 ГБ ОЗУ + 2 ядра CPU.**
