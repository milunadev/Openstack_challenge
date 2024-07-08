variable "project_name" {
  default = "challenger18"
}

variable "deploy_public_instance" {
  default = true
}

###########################################
#         NETWORK RESOURCES VARIABLES
###########################################

variable "public_network_name" {
  default = "PUBLIC"
}

variable "private_network_1_name" {
  default = "PRIVATE-1"
}

variable "private_network_2_name" {
  default = "PRIVATE-2"
}

###########################################
#         INSTANCES RESOURCES VARIABLES 
###########################################

variable "instance_image_name" {
  default = "Ubuntu 22.04 LTS"
}

variable "puppet_server_parameters" {
  default = {
    flavor_name   = "m1.small"
    volume_size   = 10
    key_pair = "PuppetKey"
  }
}

variable "puppet_agent_parameters" {
  default = {
    count = 2
    flavor_name   = "m1.small"
    volume_size   = 10
    key_pair = "puppet-agent-key"
  }
}

variable "puppet_db_parameters" {
  default = {
    flavor_name   = "m1.small"
    volume_size   = 10
    key_pair = "PuppetKey"
  }
}

variable "public_instance_parameters" {
  default = {
    instance_name = "public-instance"
    flavor_name   = "m1.small"
    key_pair = "PuppetKey"
    volume_size   = 10
  }
}
###########################################
#         OPENSTACK PROVIDER VARIABLES
###########################################

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
