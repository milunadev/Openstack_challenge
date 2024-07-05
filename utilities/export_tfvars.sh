#!/bin/bash

echo "------------------------------"
echo "UTILITIES - EXPORT TFVARS"
echo "------------------------------"

CONFIG_FILE="$HOME/.bashrc"

# Cargar las variables actuales
source "$CONFIG_FILE"

function set_env_variable {
  local var_name=$1
  local var_value=$2
  if grep -q "export $var_name=" "$CONFIG_FILE"; then
    sed -i "s|export $var_name=.*|export $var_name=\"$var_value\"|" "$CONFIG_FILE"
  else
    echo "export $var_name=\"$var_value\"" >> "$CONFIG_FILE"
  fi
}

# Función para leer valores con predeterminados
function read_with_default {
  local prompt=$1
  local default=$2
  local var
  read -p "$prompt [$default]: " var
  echo "${var:-$default}"
}

os_auth_url=$(read_with_default "Auth URL (format: 'http://x.x.x.x:5000')" "$TF_VAR_os_auth_url")
while [[ -z "$os_auth_url" ]]; do
  echo "Auth URL is required!"
  os_auth_url=$(read_with_default "Auth URL (format: 'http://x.x.x.x:5000')" "$TF_VAR_os_auth_url")
done

os_project_name=$(read_with_default "Project Name" "$TF_VAR_os_project_name")
while [[ -z "$os_project_name" ]]; do
  echo "Project Name is required!"
  os_project_name=$(read_with_default "Project Name" "$TF_VAR_os_project_name")
done

os_username=$(read_with_default "Username" "$TF_VAR_os_username")
while [[ -z "$os_username" ]]; do
  echo "Username is required!"
  os_username=$(read_with_default "Username" "$TF_VAR_os_username")
done

read -s -p "Password: " os_password
echo
while [[ -z "$os_password" ]]; do
  echo "Password is required!"
  read -s -p "Password: " os_password
  echo
done

os_region_name=$(read_with_default "Region Name" "$TF_VAR_os_region_name")
while [[ -z "$os_region_name" ]]; do
  echo "Region Name is required!"
  os_region_name=$(read_with_default "Region Name" "$TF_VAR_os_region_name")
done

os_user_domain_name=$(read_with_default "User Domain Name ('Default')" "${TF_VAR_os_user_domain_name:-Default}")
os_user_domain_name=${os_user_domain_name:-Default}

os_project_domain_id=$(read_with_default "Project Domain ID ('default')" "${TF_VAR_os_project_domain_id:-default}")
os_project_domain_id=${os_project_domain_id:-default}

export TF_VAR_os_auth_url=$os_auth_url
export TF_VAR_os_project_name=$os_project_name
export TF_VAR_os_username=$os_username
export TF_VAR_os_password=$os_password
export TF_VAR_os_region_name=$os_region_name
export TF_VAR_os_user_domain_name=$os_user_domain_name
export TF_VAR_os_project_domain_id=$os_project_domain_id

# Set variables permanently in the shell config file
set_env_variable "TF_VAR_os_auth_url" "$os_auth_url"
set_env_variable "TF_VAR_os_project_name" "$os_project_name"
set_env_variable "TF_VAR_os_username" "$os_username"
set_env_variable "TF_VAR_os_password" "$os_password"
set_env_variable "TF_VAR_os_region_name" "$os_region_name"
set_env_variable "TF_VAR_os_user_domain_name" "$os_user_domain_name"
set_env_variable "TF_VAR_os_proje
