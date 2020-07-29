terraform {
  required_version = ">= 0.12.26"
}

provider "google" {
  version = "~> 3.15.0"
}



resource "google_service_account" "array_example" {
  count      = var.enable_creation ? length(var.user_names) : 0
  account_id = "tst-acccount-id-${var.user_names[count.index]}"
  project    = var.project_name



}


