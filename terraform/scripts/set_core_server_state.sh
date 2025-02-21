#!/bin/bash

old_core_server_image_tag=$(terraform output -raw core_server_image_tag)
echo "TF_VAR_old_core_server_image_tag=$old_core_server_image_tag" >> $GITHUB_ENV
export TF_VAR_old_core_server_image_tag=$old_core_server_image_tag

echo $old_core_server_image_tag 