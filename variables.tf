variable "firewall_name" {
  default     = ""
  description = "Firewall name"
  type        = string
}

variable "droplet_name" {
  default     = "validator"
  description = "Name of the instance/Droplet"
  type        = string
}

variable "droplet_size" {
  default     = "s-4vcpu-8gb"
  description = "Droplet size (type). For Kusama `s-4vcpu-8gb` should be fine, for Polkadot maybe `m3-8vcpu-64gb`. This constantly change, check requirements section in the Polkadot wiki"
  type        = string
}

variable "region" {
  description = "Droplet region"
  type        = string
}

variable "ssh_key" {
  description = "SSH Key to use for the droplet"
  default     = ""
  type        = string
}

variable "ssh_key_id" {
  description = "DigitalOcean doesn't allow duplicate keys. If your SSH public key already exist provide its ID in this variable. Use [DigitalOcean API](https://developers.digitalocean.com/documentation/v2/#ssh-keys) to get the IDs."
  default     = ""
  type        = string
}

variable "tags" {
  default     = []
  description = "Tags for the instance"
  type        = list(any)
}

variable "disk_size" {
  description = "Disk size. Disk size. Volume is created and mounted under /home"
  default     = 200
  type        = number
}

#####################
# Application Layer #
#####################

variable "application_layer" {
  type        = string
  default     = "host"
  description = "You can deploy the Polkadot using docker containers or in the host itself (using the binary)"

  validation {
    condition     = can(regex("^docker|host", var.application_layer))
    error_message = "It can be either \"host\" or \"docker\"."
  }
}

variable "chain" {
  description = "Chain name: kusama or polkadot. Variable required to download the latest snapshot from polkashots.io"
  default     = "kusama"
}

variable "enable_polkashots" {
  default     = false
  description = "Pull latest Polkadot/Kusama (depending on chain variable) from polkashots.io"
  type        = bool
}

variable "polkadot_additional_common_flags" {
  default     = ""
  description = "CLI arguments appended to the polkadot service (e.g validator name)"
}

variable "p2p_port" {
  default     = 30333
  type        = number
  description = "P2P port for Polkadot service, used in `--listen-addr` args"
}

variable "proxy_port" {
  default     = 80
  type        = number
  description = "nginx reverse-proxy port to expose Polkadot's libp2p port. Polkadot's libp2p port should not be exposed directly for security reasons (DOS)"
}

variable "public_fqdn" {
  description = "Public domain for validator. If set, Caddy will use it to request LetsEncrypt certs. This variable is particulary useful to provide a secure channel (HTTPs) for [node_exporter](https://github.com/prometheus/node_exporter)"
  default     = ""
  type        = string
}

variable "http_username" {
  description = "Username to access endpoints (e.g node_exporter)"
  default     = ""
  type        = string
}

variable "http_password" {
  description = "Password to access endpoints (e.g node_exporter)"
  default     = ""
  type        = string
}
