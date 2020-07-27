output "external_ip" {
  value       = google_compute_instance.example.network_interface[0].access_config[0].nat_ip
  description = "внешний IP машины"
  # Если присвоить данному параметру true Terraform не станет сохранять этот вывод в журнал после выполнения команды terraform apply.
  sensitive = false
}