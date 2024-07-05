variable "public_instance_parameters" {
  type = map(any)
  default = {
    instance_name = "ubuntu-22-04"
    flavor_name   = "m1.tiny"
    key_pair = "PuppetKey"
  }
}

variable "public_network_name" {
  default = "PUBLIC"
}

variable "private_network_1_name" {
  default = "PRIVATE-1"
}

variable "private_network_2_name" {
  default = "PRIVATE-2"
}

variable "private_puppet_key" {
  
}


# variable "public_network_id" {
#   description = "The ID of the public network"
#   type        = string
# }

# variable "private_network_id" {
#   description = "The ID of the private network"
#   type        = string
# }

# variable "instance_name" {
#   description = "Name of the instance"
#   type        = string
# }

# variable "image_name" {
#   description = "Name of the image to use for the instance"
#   type        = string
# }

# variable "flavor_name" {
#   description = "Name of the flavor to use for the instance"
#   type        = string
# }

# variable "key_pair_name" {
#   description = "Name of the key pair to use for the instance"
#   type        = string
# }

# variable "private_ip" {
#   description = "Static IP address to assign to the private interface"
#   type        = string
# }

# variable "public_ip" {
#   description = "Static IP address to assign to the public interface"
#   type        = string
# }