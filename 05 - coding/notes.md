# Работа с Terraform: циклы, условные выражения, развертывание и подводные камни


## Циклы

###  count  -  параметр для циклического перебора.  

Terraform представлет несколько конструкция для итерирования между объектами
    У каждого  управляемого ресурса terraform  есть неявный параметр count, предназначенный для указния количества создаваемых объектов.

        resource "google_service_account" "object_viewer" {
        count      = 3
        account_id = "tst-acccount-id"
        }

    для итерации по количкству (count). существует итератор - count.index

        resource "google_service_account" "object_viewer" {
        count      = 3
        account_id = "tst-acccount-id-${count.index}"
        }


    для работы с массивом можно использовтаь нотацияю [] и и спользовать в ней в качестве инедекса массива переменную итератору count.index

        resource "google_service_account" "array_example" {
        count      = length(var.user_names)
        account_id = "tst-acccount-id-${var.user_names[count.index]}"
        }

    У  count  есть 2 ограничения:
    1. Его нельзя применить во вложенном блоке ресурса
    2. Его нельзя изменить - например, отресайзить массив элементов -  terraform  не увидит этого и будет пересоздавть все элементы массива.

### Циклы с выражениями for_each
    Выражение for_each  позволяет выполнить циклический перебор списков, множеств, словарей

        resource "google_service_account" "object_viewer" {
        for_each = toset(var.user_names)
        account_id = "tst-acccount-id-${each.value}"
        }

    each - это объект, котрый содержит 2 атрибута
        * value  - знаение 
        * key - ключ,  для словарей


        Одним из преимуществ for_each является, то, чт ов момент итерации можно динамически генерировать  блоки - например теги в данном сценарии

        dynamic "tag" {
            for_each = var.custom_tags
            content {
                key = tag.key
                value = tag.value
                propagate_at_launch = true
            }
        }

### Циклы с выражением for

Выражение на основе for  используются для циклического перебора элементов множества

    output "upper_names" {
        value = [for name in var.names : upper(name) if length(name) < 5]
        }
Выражения на основе  for поддерживают также итерацию по словарям,  используя синтаксис

    [for <KEY>, <VALUE> in <MAP> : <OUTPUT>]
    output "bios" {
    value = [for name, role in var.hero_thousand_faces : "${name} is the ${role}"]
    }

В выражениях for можно использовать строковую интерполяцию вида

        output "for_directive" {
        value = <<EOF
        %{~for name in var.names}
        ${name}
        %{~endfor}
        EOF
        }
    ~ это маркер необходимости удаления пробельных символов, если указана в начале - то  слева, если в конце то справа


## Условные выражения

Условные выражения в  terraform можно разделить на несколько видов:
* Параметр count для условных ресурсов
* Выражения for_each и for для условных ресурсов и их вложенных блоков
* Строковая директива if  для условных выражений внутри строк

### Условные выражения с использованием count
#### Выражения if с использованием параметра count
* Если псевдопеременной  count  в рерсурсе присвоить значение = 1, то ресурс будет создан как копия, если 0 то создан не будет вообще.
 * Terraform  поддерживает синтаксис тернарного оператора (<CONDITION>?<TRUE_VAL>:<FALSE_VAL>)


для реализации условия создания  ресурса используется следующий хак

объявляется булева переменная

    variable "enable_creation" {
    description = "Надо ли создавать ресурс"
    type        = bool
        }

    resource "google_service_account" "array_example" {
    count      = var.enable_creation ? length(var.user_names):0
    account_id = "tst-acccount-id-${var.user_names[count.index]}"
    project= var.project_name
    }


использование через шаблон  текстовой переменной

         count = format("%.1s", var.instance_type) == "t" ? 1 : 0

#### Выражения if-else с использованием параметра count
Если есть всего лишь булева логика, то создается 2 ресурса, у котрых инвертирован 0 по условию

    count = var.give_neo_cloudwatch_full_access ? 1 : 0
    count = var.give_neo_cloudwatch_full_access ? 0 : 1

### Условная логика с использованием выражений for_each и for

для выражений for_each и for условная логика реализуется на размере коллекции, если в коллекции нет элементов, ресурс создан не будет, иначе будут созданы ресурсы по элементам коллекции.

    dynamic "tag" {
        for_each = {
        for key, value in var.custom_tags :
        key => upper(value)
        if key != "Name"
        }
        content {
        key                 = tag.key
        value               = tag.value
        propagate_at_launch = true
        }
    }

Филтрация на основе итерации с фильтрацией по for_each предпочительней чем манипуляции с count,
count - предпочитать при созданнии ресурсов


### Условные выражения с использованием строковой директивы if
Реализуется лексемой вида 
    
    %{ if <CONDITION> }<TRUEVAL>%{ endif }
      CONDITION - булево выражение 
      TRUEVAL - значение при  true
      можно такж заиспользовать Else 

пример 

    output "if_else_directive" {
    value = "Hello, %{if var.name != ""}${var.name}%{else}(unnamed)%{endif}"
    }



## Развертывание с нулевым временем простоя



## Подводные камни Terraform