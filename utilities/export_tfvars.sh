#!/bin/bash

echo "------------------------------"
echo "UTILITIES - EXPORT TFVARS"
echo "------------------------------"

CONFIG_FILE="$HOME/.bashrc"

read_and_export_variable() {
    local var_name=$1
    read -p "Enter value for $var_name: " var_value
    export $var_name="$var_value"
    echo "export $var_name=\"$var_value\"" >> "$CONFIG_FILE"
}

variables=("os_auth_url" "os_project_name" "os_username" "os_password" "os_region_name" "os_user_domain_name" "os_project_domain_id")

for variable in "${variables[@]}"; do
    read_and_export_variable "TF_VAR_$variable"
done

source "$CONFIG_FILE"

echo "Environment variables set:"
echo "TF_VAR_os_auth_url=\"$TF_VAR_os_auth_url\""
echo "TF_VAR_os_project_name=\"$TF_VAR_os_project_name\""
echo "TF_VAR_os_username=\"$TF_VAR_os_username\""
echo "TF_VAR_os_region_name=\"$TF_VAR_os_region_name\""
echo "TF_VAR_os_user_domain_name=\"$TF_VAR_os_user_domain_name\""
echo "TF_VAR_os_project_domain_id=\"$TF_VAR_os_project_domain_id\""
