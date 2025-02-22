#!/bin/bash

old_core_server_image_tag=$(terraform output -raw core_server_image_tag)
echo $old_core_server_image_tag

old_core_server_secrets=$(terraform output -json core_server_secrets 2>/dev/null || echo [])
echo $old_core_server_secrets

if [ -n "$GITHUB_ENV" ]; then  
  echo TF_VAR_old_core_server_image_tag=$old_core_server_image_tag >> "$GITHUB_ENV"
  echo TF_VAR_old_core_server_secrets=$old_core_server_secrets >> "$GITHUB_ENV"
else
  export TF_VAR_old_core_server_image_tag=$old_core_server_image_tag
  export TF_VAR_old_core_server_secrets=$old_core_server_secrets
fi
