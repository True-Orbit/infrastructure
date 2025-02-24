output "web_image_tag" {
  value = local.web_image_tag
}

output "web_service_secrets" {
  value = local.web_service_secrets
  sensitive = true
}

output "core_server_image_tag" {
  value = local.core_server_image_tag
}

output "core_server_secrets" {
  value = local.core_server_secrets
  sensitive = true
}

output "vpc_id" {
  value = module.foundation.vpc_id
}

output "public_subnet_id" {
  value = module.foundation.public_subnet_a_id
}