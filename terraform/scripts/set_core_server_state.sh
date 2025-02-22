#!/bin/bash

old_core_server_image_tag=$(terraform output -raw core_server_image_tag)
echo TF_VAR_old_core_server_image_tag=$old_core_server_image_tag >> "$GITHUB_ENV"
export TF_VAR_old_core_server_image_tag=$old_core_server_image_tag

echo $old_core_server_image_tag

old_core_server_secrets=$(terraform output -raw core_server_secrets 2>/dev/null || echo [])
echo TF_VAR_old_core_server_secrets=$old_core_server_secrets >> "$GITHUB_ENV"
export TF_VAR_old_core_server_secrets=$old_core_server_secrets

echo $old_core_server_secrets