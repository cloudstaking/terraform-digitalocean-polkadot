variable "droplet_name" {
  description = "Name of the instance/Droplet"
}

variable "ssh_key" {
  description = "SSH Key to use for the droplet"
}

variable "ssh_key_id" {
  description = "DigitalOcean doesn't allow duplicate keys. If your SSH public key already exist provide its ID in this variable. Use [DigitalOcean API](https://developers.digitalocean.com/documentation/v2/#ssh-keys) to get the IDs."
  default     = ""
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "enable_polkashots" {
  description = "Pull latest Polkadot/Kusama (depending on chain variable) from polkashots.io"
  type        = bool
}

variable "additional_volume" {
  description = "By default, s-4vcpu-8gb comes with 150GB disk size. Set this variable in order to create an additional volume (mounted in /srv)"
  type        = bool
}
