#!/bin/bash

echo "------------------------------"
echo "UTILITIES - EXPORT TFVARS"
echo "------------------------------"

CONFIG_FILE="$HOME/.bashrc"

read_and_export_variable() {
    local var_name=$1
    read -p "Enter value for $var_name: " var_value
    export $var_name="$var_value"
    echo "export $var_name='$var_value'" >> "$CONFIG_FILE"
}

set_env_variable() {
    local var_name=$1
    local var_value=$2
    if grep -q "export $var_name=" "$CONFIG_FILE"; then
        sed -i "s|export $var_name=.*|export $var_name='$var_value'|" "$CONFIG_FILE"
    else
        echo "export $var_name='$var_value'" >> "$CONFIG_FILE"
    fi
}

variables=("os_auth_url" "os_project_name" "os_username" "os_password" "os_region_name" "os_user_domain_name" "os_project_domain_id")

for variable in "${variables[@]}"; do
    read_and_export_variable "TF_VAR_$variable"
    set_env_variable "TF_VAR_$variable" "$(eval echo \$TF_VAR_$variable)"
done

source "$CONFIG_FILE"

echo "Environment variables set:"
for variable in "${variables[@]}"; do
    var_name="TF_VAR_$variable"
    echo "$var_name=\"$(eval echo \$$var_name)\""
done
