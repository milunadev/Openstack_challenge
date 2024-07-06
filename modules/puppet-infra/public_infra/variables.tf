variable "public_instance_parameters" {
  type = map(any)
}

variable "public_network_name" {}

variable "private_network_1_name" {}

variable "private_network_2_name" {}

variable "instance_image_name" {}

variable "puppet_agent_key" {}
variable "puppet_server_key" {}
variable "puppet_db_key" {}