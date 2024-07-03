terraform {
  required_version = ">= 0.14.5"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.53.0"
    }
  }
}

provider "openstack" {
  user_name         = var.os_username
  tenant_name       = var.os_project_name
  password          = var.os_password
  auth_url          = var.os_auth_url
  region            = var.os_region_name
  user_domain_name  = var.os_user_domain_name
  project_domain_id = var.os_project_domain_id
}