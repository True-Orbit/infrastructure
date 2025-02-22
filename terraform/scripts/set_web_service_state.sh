#!/bin/bash

old_web_image_tag=$(terraform output -raw web_image_tag)
echo "TF_VAR_old_web_image_tag=$old_web_image_tag" >> "$GITHUB_ENV"
export TF_VAR_old_web_image_tag=$old_web_image_tag

echo $old_web_image_tag

old_web_service_secrets=$(terraform output -raw web_service_secrets 2>/dev/null || echo [])
echo "TF_VAR_old_web_service_secrets=$old_web_service_secrets" >> "$GITHUB_ENV"
export TF_VAR_old_web_service_secrets=$old_web_service_secrets

echo $old_web_service_secrets