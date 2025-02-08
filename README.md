# True Orbit Infrastructure
  - Deploying using Terraform for IaC

## Requirements
  - nginx (local reverse proxy)

### Local Setup
  - Pull down repos
  - Follow their setup instructions
  - Download and run Nginx
  - Download and add the local nginx config
  ```
  curl -o /opt/homebrew/etc/nginx/external-config/true-orbit.conf https://raw.githubusercontent.com/True-Orbit/infrastructure/main/local-nginx.conf
  ```

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
    - run `source ./script/set_image_tag_envs.sh` to make sure your image variables are up to date
