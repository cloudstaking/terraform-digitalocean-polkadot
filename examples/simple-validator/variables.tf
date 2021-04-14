variable "droplet_name" {
  description = "Name of the instance/Droplet"
}

variable "ssh_key" {
  description = "SSH Key to use for the droplet"
  default     = ""
}
