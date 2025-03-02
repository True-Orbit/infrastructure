# True Orbit Infrastructure
  - Deploying using Terraform for IaC

## Requirements
  - nginx (local reverse proxy)

### Local Setup
  - Pull down repos
  - Follow their setup instructions
  - Download and run Nginx
  - Install a ssl certificate 
  ```
  brew install mkcert
  brew install nss # if you use Firefox
  ```
  - Download and add the local nginx config
  ```
  curl -o /opt/homebrew/etc/nginx/external-config/true-orbit.conf https://raw.githubusercontent.com/True-Orbit/infrastructure/main/local/local-nginx.conf
  ```
  - Copy the ssl certificates
  ```
   curl -o /opt/homebrew/etc/nginx/ssl/local.trueorbit.me.pem https://raw.githubusercontent.com/True-Orbit/infrastructure/main/local/local.trueorbit.me.pem
  ```
  ```
   curl -o /opt/homebrew/etc/nginx/ssl/local.trueorbit.me-key.pem https://raw.githubusercontent.com/True-Orbit/infrastructure/main/local/local.trueorbit.me-key.pem
  ```
  - Or make your own
  ```
  mkcert local.trueorbit.me
  ```
  - then copy the 2 certs to `/opt/homebrew/etc/nginx/ssl/`

  - Include true orbit server config in your Nginx config under the http block
    - Might need to create folder external-config
  ```
    include /opt/homebrew/etc/nginx/external-config/true-orbit.conf;
  ```
  - add `local.trueorbit.me` to your /etc/hosts file

  - restart Nginx

### Terraform Plan / Apply
  - Secrets
    - direnv is helpful
    - Make sure you have rds, hostedZone in your env variables
    - run `source ./script/set_current_state.sh` to make sure your image variables are up to date

### Core Server Migrations
  - Handles Migrations and seeds for core server
  - Navigate to true-orbit folder
  - `source ./scripts/set_current_state`
  - Navigate to core_server_ec2
  - `terraform apply`
  - Choose migrations and/or seeds
  - `terraform destroy` when it's done