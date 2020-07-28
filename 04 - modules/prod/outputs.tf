output "external_ip" {
  value       = module.webserver.external_ip
  description = "внешний IP машины"
  sensitive = false
}
 

  

