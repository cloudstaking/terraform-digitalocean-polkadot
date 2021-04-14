output "validator_public_ip" {
  value       = digitalocean_droplet.validator.ipv4_address
  description = "Validator public IP address, you can use it to SSH into it"
}

output "http_username" {
  value       = module.cloud_init.http_username
  description = "Username to access private endpoints (e.g node_exporter)"
}

output "http_password" {
  value       = module.cloud_init.http_password
  description = "Password to access private endpoints (e.g node_exporter)"
}
