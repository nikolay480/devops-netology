# Devops-Netology
# 3.1. Домашнее задание к занятию «Инструменты Git»

### Цель задания

В результате выполнения этого задания вы научитесь работать с утилитами Git и  потренируетесь решать типовые задачи, возникающие при работе в команде. 

### Инструкция к заданию

1. Склонируйте [репозиторий](https://github.com/hashicorp/terraform) с исходным кодом Terraform.
2. Создайте файл для ответов на задания в своём репозитории, после выполнения, прикрепите ссылку на .md-файл с ответами в личном кабинете.
3. Любые вопросы по решению задач задавайте в чате учебной группы.

------

## Задание

В клонированном репозитории:

1. Найдите полный хеш и комментарий коммита, хеш которого начинается на `aefea`.
```bash
$:git show aefea
commit aefead2207ef7e2aa5dc81a34aedf0cad4c32545
```
2. Какому тегу соответствует коммит `85024d3`?
```bash
$:git show 85024d3
tag: v0.12.23
````
4. Сколько родителей у коммита `b8d720`? Напишите их хеши.
```bash
$:git checkout b8d720
$:git log --pretty=format:'%h %s' –graph
56cd7859e0, 9ea88f22fc
```
5. Перечислите хеши и комментарии всех коммитов которые были сделаны между тегами  v0.12.23 и v0.12.24.
````bash
$:git log --oneline v0.12.23..v0.12.24
b14b74c493 [Website] vmc provider links
3f235065b9 Update CHANGELOG.md
6ae64e247b registry: Fix panic when server is unreachable
5c619ca1ba website: Remove links to the getting started guide's old location
06275647e2 Update CHANGELOG.md
d5f9411f51 command: Fix bug when using terraform login on Windows
4b6d06cc5d Update CHANGELOG.md
dd01a35078 Update CHANGELOG.md
225466bc3e Cleanup after v0.12.23 release
````
6. Найдите коммит в котором была создана функция `func providerSource`, ее определение в коде выглядит 
так `func providerSource(...)` (вместо троеточия перечислены аргументы).
```bash
$:git log -S "func providerSource"

commit 8c928e83589d90a031f811fae52a81be7153e82f
Date:   Thu Apr 2 18:04:39 2020 -0700
````
7. Найдите все коммиты, в которых была изменена функция `globalPluginDirs`.
```bash
$:git grep -p "globalPluginDirs("
git log -L :globalPluginDirs:plugins.go
8364383c35 Push plugin discovery down into command package
66ebff90cd move some more plugin search path logic to command
41ab0aef7a Add missing OS_ARCH dir to global plugin paths
52dbf94834 keep .terraform.d/plugins for discovery
78b1220558 Remove config.go and update things using its aliases
````
8. Кто автор функции `synchronizedWriters`? 
```bash
$:git log -S ‘func providerSource’
Author: Martin Atkins <mart@degeneration.co.uk>
Date:   Wed May 3 16:25:41 2017 -0700
````

*В качестве решения ответьте на вопросы и опишите каким образом эти ответы были получены*

---


#