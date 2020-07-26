terraform {
  required_version = ">= 0.12.26"
}

provider "google" {
  version = "~> 3.15.0"
  project = var.project_name
  region  = var.region_name
  zone    = var.location_name
}


resource "google_storage_bucket" "av_terraform_bucket" {
  name     = var.bucket_name
  location = var.region_name

  # чтоб не грохнуть при дестрое
  lifecycle {
    prevent_destroy = true
  }

  # включаем версиоенирование
  versioning {
    enabled = true
  }
  force_destroy = false
}
