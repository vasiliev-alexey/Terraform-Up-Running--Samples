terraform {
  required_version = ">= 0.12.26"
}

provider "google" {
  version = "~> 3.15.0"
  project = var.project_name
  region  = var.region_name
  zone    = var.location_name
}

module "webserver" {
source="../modules/services/webserver"
  project_name = var.project_name
  region_name  = var.region_name
  location_name    = var.location_name
  machine_type = var.machine_type
  instance_name = "production_server"
}
