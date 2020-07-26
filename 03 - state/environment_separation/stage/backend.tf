
# Бекенд для хранения
terraform {
  backend "gcs" {
    bucket = "av_terraform_bucket" # GCS bucket name to store terraform tfstate
    prefix = "env_stage"
  }
}
 