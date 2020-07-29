variable "user_names" {
  description = "Create IAM users with these names"
  type        = list(string)
  default     = ["neo", "trinity", "morpheus"]
}


variable "enable_creation" {
  description = "Надо ли создавать ресурс"
  type        = bool
  default     = true
}



variable "project_name" {
  description = "Надо ли создавать ресурс"
  type        = string

}
