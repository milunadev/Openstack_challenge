################################################################
#                   GENERAL RESOURCES VARIABLES
################################################################
variable "project_name" {
  description = "The name of the project, used to name resources of puppet infraestructure"
}

variable "deploy_public_instance" {}
################################################################
#                   NETWORK RESOURCES VARIABLES
################################################################
variable "public_network_name" {
  description = "The name of the public network"
}

variable "private_network_1_name" {
  description = "The name of the private network"
}

variable "private_network_2_name" {
  description = "The name of a second private network if needed"
}   

################################################################
#                   INSTANCES RESOURCES VARIABLES 
################################################################

variable "puppet_agent_parameters" {
  description = "Parameters for puppet agent instances. Include number of instances to horizontal scale and flavor name to vertical scale"
  type = map(any)
}


variable "puppet_db_parameters" {
  description = "Parameters for puppet db instances. Include flavor name to vertical scale"
  type = map(any)
}


variable "puppet_server_parameters" {
  description = "Parameters for puppet server instances. Include flavor name to vertical scale"
  type = map(any)
}

variable "instance_image_name" {
  default = "Ubuntu 22.04 LTS"
}

variable "public_instance_parameters" {
  description = "Parameters for public instances"
  type = map(any)
}