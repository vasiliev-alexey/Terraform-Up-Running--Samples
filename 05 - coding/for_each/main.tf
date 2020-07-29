terraform {
  required_version = ">= 0.12.26"
}

provider "google" {
  version = "~> 3.15.0"
}



resource "google_service_account" "object_viewer" {
  for_each   = toset(var.user_names)
  account_id = "tst-acccount-id-${each.value}"
}