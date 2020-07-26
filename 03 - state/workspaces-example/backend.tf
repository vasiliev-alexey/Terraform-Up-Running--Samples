
# Бекенд для хранения настроек
terraform {
  backend "gcs" {
    bucket = "av_terraform_bucket" # GCS bucket name to store terraform tfstate
    prefix = "workspace_simple_web_server"
  }
}
 