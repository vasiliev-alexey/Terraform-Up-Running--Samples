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



variable "bucket_name" {
  description = "GCS Bucket name. Value should be unique ."
  type        = string
  default     = "av_terraform_bucket"
}


