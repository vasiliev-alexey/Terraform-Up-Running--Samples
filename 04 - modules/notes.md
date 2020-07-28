# Заметки

## Определение модуля
для разбиения на модули - требутся создать  отдельный каталог  со стандартной структурой файлов TF

        module\sample\
                    - main.tf
                    - variables.tf
                    - output.tf

Созданный модуль далее можно переиспользовать в проекте  декларируя его 

        module "webserver" {
        source="../modules/services/webserver"
        }


## Входные пераметры модуля 
Модуль может иметь входные параметры - котрые обявляются по стандарту в файле  variables.tf

В использующем модуль файле, необходимо использовать именнованную натоцию при инициализации модуля

    module "webserver" {
    source="../modules/services/webserver"

    project_name = var.project_name
    region_name  = var.region_name
    location_name    = var.location_name
    machine_type = var.machine_type
    instance_name = "production_server"
    
    }


## Локальные переменные модуля 
Модуль может иметь локальные переменный для избежания дублирования  значений - в файле они обьявлюятся как 

    locals {
    http_port    = 80
    any_port     = 0
    any_protocol = "-1"
    tcp_protocol = "tcp"
    all_ips      = ["0.0.0.0/0"]
    }


Затем используются в файле модуля с указанием скоупа  local

    source_ranges = [
        local.all_ips
    ]


## Выходные переменные модуля

Для обьявления выходных параметров модуля испольузется их декларирование в файле  outputs.tf

    output "external_ip" {
        value       = google_compute_instance.example.network_interface[0].access_config[0].nat_ip
        description = "внешний IP машины"
        # Если присвоить данному параметру true Terraform не станет сохранять этот вывод в журнал после выполнения команды terraform apply.
        sensitive = false
    }

Для обращения к выходным переменным модуля используется следующий синтаксис:
module.<MODULE_NAME>.<OUTPUT_NAME>

        output "external_ip" {
        value       = module.webserver.external_ip
        description = "внешний IP машины"
        sensitive = false
        }
 
 ## Файловые пути

  Файловые пути указанные в файлах terraform - расчитываются исходя из указания  корня проекта, откуда производиится запуск, но при  разработке серез модули, этоя может оказаться проблемой - так как модули могут иметь другое расположение. Для выхода из этой ситуации испольузется выражение "ссылка на путь"
  
  Terraform поддерживает следующие типы ссылок:
* path.module —.возвращает путь к модулю, в.котором определено выражение.
* path.root — возвращает путь к корневому модулю.
* path.cwd — возвращает путь к текущей рабочей папке.

        data "template_file" "user_data" {
        template = file("${path.module}/user-data.sh")
        }

## Управление версиями
Использование модулей в локальной директории может создать конфликты. Измнение в модуле может затроноуть другие проекты,
ссылающиеся на этот модуль.
Для решения это ситуации Terraform поддержиывает ссылки на модуль через GIT и раздление весий например через теги.


        module "webserver_cluster" {
        source = "github.com/foo/modules//webserver-cluster?ref=v0.0.1"
 
        }

