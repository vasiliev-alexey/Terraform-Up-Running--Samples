variable "project_name" {
   type = string
}

variable "region_name" {
  default = "europe-west1"
}

variable "location_name" {
  default = "europe-west1-b"
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8080
}

variable "source_ranges" {
  description = "source range of  ip4v"
  type        = string
  default     = "0.0.0.0/0"
}

variable "machine_type" {
  description = "Тип машины  в GCP"
  type        = string
  default     = "f1-micro"
}








# Структурная входна переменнная
variable "object_example" {
  description = "An example of a structural type in Terraform"
  type = object({ name = string
    age     = number
    tags    = list(string)
    enabled = bool
  })
  default = {
    name    = "value1"
    age     = 42
    tags    = ["a", "b", "c"]
    enabled = true
  }
}

# переменная с ошибкой

/*
variable "object_example_with_error" {
  description = "An example of a structural type in Terraform with an error"
  type = object({
    name    = string
    age     = number
    tags    = list(string)
    enabled = bool
  })
  default = {
    name    = "value1"
    age     = 42
    tags    = ["a", "b", "c"]
    enabled = "invalid"
  }
}
#  генерирует ошибку:
Error: Invalid default value for variable

  on terraform.tf line 38, in variable "object_example_with_error":
  38:   default = {
  39:     name    = "value1"
  40:     age     = 42
  41:     tags    = ["a", "b", "c"]
  42:     enabled = "invalid"
  43:   }

This default value is not compatible with the variable's type constraint: a
bool is required.

*/
