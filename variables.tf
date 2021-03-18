variable "enable_firewall" {
  description = "If true, DigitalOcean firewall is enabled with some default rules"
  default     = true
  type        = bool
}

variable "firewall_name" {
  default     = "validator"
  description = "Firewall name (some cloud providers call this \"security group\")"
}

variable "firewall_whitelist_ip_ssh" {
  default     = ["0.0.0.0/0"]
  description = "List of CIDRs that droplet is going to accept SSH connections from"
}

variable "droplet_name" {
  default     = "validator"
  description = "Name of the Droplet"
}

variable "droplet_size" {
  default     = "s-4vcpu-8gb"
  description = "Droplet size (type). For Kusama s-4vcpu-8gb is fine"
}

variable "region" {
  description = "Droplet region"
}

variable "additional_volume" {
  description = "By default, s-4vcpu-8gb comes with 150GB disk size. Set to true to create an additional volume and mount it under /srv"
  default     = false
  type        = bool
}

variable "additional_volume_size" {
  description = "By default, s-4vcpu-8gb comes with 150GB disk size. If you want an additional volume under /srv"
  default     = 10
}

variable "chain" {
  description = "Which chain you are using: kusama or polkadot. It is used to download the latest snapshot from polkashots.io"
  default     = "kusama"
}

variable "ssh_keys" {
  default     = []
  description = "A list of SSH IDs, use [DigitalOcean API](https://developers.digitalocean.com/documentation/v2/#ssh-keys) to get the IDs. You can also reset the password from the DigitalOcean console."
}

variable "enable_polkashots" {
  default     = true
  description = "Pull the latest Polkadot/Kusama (depending on chain variable) from polkashots.io"
  type        = bool
}
