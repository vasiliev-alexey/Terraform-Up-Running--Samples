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

}
