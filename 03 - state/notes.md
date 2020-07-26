# Заметки

## Ссылки на метериалы
- [Официальная дока](https://www.terraform.io/docs/backends/types/gcs.html)
- [Как настроить - статья на медиум](https://medium.com/@gmusumeci/how-to-configure-the-gcp-backend )  
 - [Еще 1 статья](https://pbhadani.com/posts/first-gcp-resource-with-terraform/)


## Дедупликация ключей бекенда
 Чтобы частично избавиться от дедупликации файлов бекенда Terraform -  ее можно вынести в отдедбный файл вида
 backend.hcl

        # backend.hcl
        bucket = "terraform-up-and-running-state"
        region = "us-east-2"
        dynamodb_table = "terraform-up-and-running-locks"
        encrypt = true

И исползовать конфигурацию  при запуске 

        terraform init -backend-config=backend.hcl
    
 

 ## Изоляция файлов состояний
Файлы состояний можно изодировать  
    - через workspace  
    - через изоляцию каталогов 

### workspaces  
         terraform workspace new XXX
         terraform workspace list
         terraform workspace select default
         
### Каталоги
    \.
    -\prod
    -\stage
    -\global
    -\vpc



## Terraform remote backend 
у terraform есть возможность считать из файла состояния другого проекта - переменные и использовать их в другом проекте.  
для этого нужно чтобы модуль из которого надо  вычитать пеменные хранил свое состояние в S3 бакете

Далее объявлем выходные переменные модуля

    output "address" {
        value = aws_db_instance.example.address
        description = "Connect to the database at this endpoint"
        }
        output "port" {
        value = aws_db_instance.example.port
        description = "The port the database is listening on"
        }
В своем модуле создаем блок с данными 

    data "terraform_remote_state" "db" {
        backend = "s3"
        config = {
        bucket = "(YOUR_BUCKET_NAME)"
        key = "stage/data-stores/mysql/terraform.tfstate"
        region = "us-east-2"
        }
        }


И далее  в своем проекте  используем ссылки для зависимостей вида

    data.terraform_remote_state.<NAME>.outputs.<ATTRIBUTE>