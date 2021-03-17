output "validator_public_ip" {
  value       = digitalocean_droplet.validator.ipv4_address
  description = "Validator public IP address, you can use it to SSH into it"
}
