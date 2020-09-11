#!/bin/bash

################################################################################
#
# accentis-bootstrap Script
#
# This script runs the accentis-bootstrap procedure.  Refer to the accompanying
# README.md file for a list of prerequisites that must be satisfied prior to
# running this script.
#
################################################################################

# Setting Shell Options
set -eu${DEBUG+x}o pipefail

# Determine the absolute path of the directory containing this script
root_directory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Include the functions needed by this script
. $root_directory/functions.sh.source

# Pre-flight checks
check_bash
check_docker
check_state_file

# Parse the command line arguments
terraform_command=${1:-"help"}
shift

if [[ $terraform_command == destroy ]]; then
    echo "WARNING: The resources in this project are not intended to be destroyed.  Destroying any of these resources could have devasting impacts to down-stream projects."
    read -p "Are you ABSOLUTELY certain that you want to proceed? (you must type yEs with that capitalization to proceed): " answer

    if [[ $answer != yEs ]]; then
        exit 0
    fi
fi

# Create temporary directory for this execution and set a trap to delete it
work_directory=$(mktemp -d $root_directory/work-XXXXXXXX)
trap "rm -rf $work_directory" EXIT

# Check if Accentis Vault is available
if accentis_vault_usable ; then
    # Obtain Google Cloud Platform credentials from Accentis Vault
    mkdir -p $work_directory/gcp_creds
    accentis_vault read -field=private_key_data gcp/key/terraform-bootstrap | base64 --decode > $work_directory/gcp_creds/application_default_credentials.json

    # Obtain Terraform Cloud API Token from Accentis Vault
    terraform_cloud_token=$(accentis_vault kv get -field=api-token kv-deploy/terraform-cloud/bootstrap || prompt_secret "Terraform Cloud API Token")
else
    # Obtain Google Cloud Platform credentials
    gcp_login $work_directory

    # Obtain Terraform Cloud API Token
    terraform_cloud_token=$(prompt_secret "Terraform Cloud API Token")
fi

# Run Terraform
run_terraform "$@"
