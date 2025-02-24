#!/bin/bash

vpc_id=$(terraform output -raw vpc_id)
echo $vpc_id

public_subnet_id=$(terraform output -json public_subnet_id 2>/dev/null || echo [])
echo $public_subnet_id

export vpc_id="$vpc_id"
export public_subnet_id="$public_subnet_id"

if [ -n "$GITHUB_ENV" ]; then  
  echo vpc_id=$vpc_id >> "$GITHUB_ENV"
  echo public_subnet_id=$public_subnet_id >> "$GITHUB_ENV"
fi
