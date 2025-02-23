output "dns_name" {
  value = aws_route53_zone.true_orbit.name
}

output "dns_zone_id" {
  value = aws_route53_zone.true_orbit.zone_id
}