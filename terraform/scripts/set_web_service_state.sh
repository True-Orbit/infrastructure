#!/bin/bash

old_web_service_image_tag=$(terraform output -raw web_image_tag)
echo $old_web_service_image_tag

export TF_VAR_old_web_service_image_tag=$old_web_service_image_tag