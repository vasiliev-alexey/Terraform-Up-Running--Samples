variable "project_name" {
  type = string
}

variable "region_name" {
  default = "europe-west1"
}

variable "location_name" {
  default = "europe-west1-b"
}

variable "bucket_name" {
  description = "GCS Bucket name. Value should be unique ."
  type        = string
  default     = "av_terraform_bucket"
}

