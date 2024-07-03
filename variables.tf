variable "os_auth_url" {
  description = "The OpenStack authentication URL"
  type        = string
}

variable "os_project_name" {
  description = "The OpenStack project name"
  type        = string
}

variable "os_username" {
  description = "The OpenStack username"
  type        = string
}

variable "os_password" {
  description = "The OpenStack password"
  type        = string
  sensitive   = true
}

variable "os_region_name" {
  description = "The OpenStack region name"
  type        = string
}

variable "os_user_domain_name" {
  description = "The OpenStack user domain name"
  type        = string
}

variable "os_project_domain_id" {
  description = "The OpenStack project domain ID"
  type        = string
}
