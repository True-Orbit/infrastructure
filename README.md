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
  ```
    include /opt/homebrew/etc/nginx/external-config/true-orbit.conf;
  ```
  - add `local.trueorbit.me` to your /etc/hosts file

  - restart Nginx