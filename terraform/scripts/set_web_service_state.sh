#!/bin/bash

old_web_image_tag=$(terraform output -raw web_image_tag)
echo $old_web_image_tag

old_web_service_secrets=$(terraform output -json web_service_secrets 2>/dev/null || echo [])
echo $old_web_service_secrets

export TF_VAR_old_web_service_image_tag="$old_web_image_tag"
export TF_VAR_old_web_service_secrets="$old_web_service_secrets"

if [ -n "$GITHUB_ENV" ]; then 
  echo TF_VAR_old_web_service_image_tag=$old_web_image_tag >> "$GITHUB_ENV"
  echo TF_VAR_old_web_service_secrets=$old_web_service_secrets >> "$GITHUB_ENV"
fi