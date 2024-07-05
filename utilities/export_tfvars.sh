#!/bin/bash

echo "------------------------------"
echo "UTILITIES - EXPORT TFVARS"
echo "------------------------------"

CONFIG_FILE="$HOME/.bashrc"

function set_env_variable {
  local var_name=$1
  local var_value=$2
  if grep -q "export $var_name=" "$CONFIG_FILE"; then
    sed -i "s|export $var_name=.*|export $var_name=\"$var_value\"|" "$CONFIG_FILE"
  else
    echo "export $var_name=\"$var_value\"" >> "$CONFIG_FILE"
  fi
}

read -p "Auth URL (format: 'http://x.x.x.x:5000'): " os_auth_url
while [[ -z "$os_auth_url" ]]; do
  echo "Auth URL is required!"
  read -p "Auth URL (format: 'http://x.x.x.x:5000'): " os_auth_url
done

read -p "Project Name [$os_project_name]: " os_project_name
while [[ -z "$os_project_name" ]]; do
  echo "Project Name is required!"
  read -p "Project Name [$os_project_name]: " os_project_name
done

read -p "Username [$os_username]: " os_username
while [[ -z "$os_username" ]]; do
  echo "Username is required!"
  read -p "Username [$os_username]: " os_username
done

read -s -p "Password: " os_password
echo
while [[ -z "$os_password" ]]; do
  echo "Password is required!"
  read -s -p "Password: " os_password
  echo
done

read -p "Region Name [$os_region_name]: " os_region_name
while [[ -z "$os_region_name" ]]; do
  echo "Region Name is required!"
  read -p "Region Name [$os_region_name]: " os_region_name
done

read -p "User Domain Name ('Default') [Default]: " os_user_domain_name
os_user_domain_name=${os_user_domain_name:-Default}

read -p "Project Domain ID ('default') [default]: " os_project_domain_id
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
set_env_variable "TF_VAR_os_project" "$os_project_name"
set_env_variable "TF_VAR_os_username" "$os_username"
set_env_variable "TF_VAR_os_password" "$os_password"
set_env_variable "TF_VAR_os_region_name" "$os_region_name"
set_env_variable "TF_VAR_os_user_domain_name" "$os_user_domain_name"
set_env_variable "TF_VAR_os_project_domain_id" "$os_project_domain_id"

source "$CONFIG_FILE"

echo "Environment variables set:"
echo "OS_AUTH_URL=$TF_VAR_os_auth_url"
echo "OS_PROJECT_NAME=$TF_VAR_os_project_name"
echo "OS_USERNAME=$TF_VAR_os_username"
echo "OS_REGION_NAME=$TF_VAR_os_region_name"
echo "OS_USER_DOMAIN_NAME=$TF_VAR_os_user_domain_name"
echo "OS_PROJECT_DOMAIN_ID=$TF_VAR_os_project_domain_id"
