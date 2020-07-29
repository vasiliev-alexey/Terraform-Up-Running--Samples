terraform {
  required_version = ">= 0.12.26"
}

provider "google" {
  version = "~> 3.15.0"
}

resource "google_service_account" "object_viewer" {
  count      = 3
  account_id = "tst-acccount-id-${count.index}"
}


resource "google_service_account" "array_example" {
  count      = length(var.user_names)
  account_id = "tst-acccount-id-${var.user_names[count.index]}"
}


