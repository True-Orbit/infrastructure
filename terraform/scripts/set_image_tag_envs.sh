#!/bin/bash

export TF_VAR_old_web_service_image_tag=$(terraform output -raw web_image_tag)
export TF_VAR_old_core_server_image_tag=$(terraform output -raw core_server_image_tag)