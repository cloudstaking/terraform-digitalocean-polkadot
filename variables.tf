variable "firewall_name" {
  default     = ""
  description = "Firewall name"
}

variable "firewall_whitelisted_ssh_ip" {
  default     = ["0.0.0.0/0"]
  description = "List of CIDRs the instance is going to accept SSH connections from"
}

variable "droplet_name" {
  default     = "validator"
  description = "Name of the instance/Droplet"
}

variable "droplet_size" {
  default     = "s-4vcpu-8gb"
  description = "Droplet size (type). For Kusama `s-4vcpu-8gb` should be fine, for Polkadot maybe `m3-8vcpu-64gb`. This constantly change, check requirements section in the Polkadot wiki"
}

variable "region" {
  description = "Droplet region"
}

variable "additional_volume" {
  description = "By default, s-4vcpu-8gb comes with 150GB disk size. Set this variable in order to create an additional volume (mounted in /srv)"
  default     = false
  type        = bool
}

variable "additional_volume_size" {
  description = "By default, s-4vcpu-8gb comes with 150GB disk size. If you want an additional volume under /srv"
  default     = 200
}

variable "chain" {
  description = "Chain name: kusama or polkadot. Variable required to download the latest snapshot from polkashots.io"
  default     = "kusama"
}

variable "ssh_key" {
  description = "SSH Key to use for the droplet"
  default     = ""
}

variable "ssh_key_id" {
  description = "DigitalOcean doesn't allow duplicate keys. If your SSH public key already exist provide its ID in this variable. Use [DigitalOcean API](https://developers.digitalocean.com/documentation/v2/#ssh-keys) to get the IDs."
  default     = ""
}

variable "enable_polkashots" {
  default     = true
  description = "Pull latest Polkadot/Kusama (depending on chain variable) from polkashots.io"
  type        = bool
}

variable "tags" {
  default     = []
  description = "Tags for the instance"
}

variable "polkadot_additional_common_flags" {
  default     = ""
  description = "Application layer, the content of this variable will be appended to the polkadot command arguments"
}
