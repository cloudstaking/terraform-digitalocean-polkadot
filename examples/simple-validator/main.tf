
terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
    }
    github = {
      source = "integrations/github"
    }
  }
  required_version = ">= 0.13"
}

# Provider(s)
provider "digitalocean" {}

module "validator" {
  source = "../../"

  droplet_name      = var.droplet_name
  region            = "lon1"
  ssh_key           = var.ssh_key
  ssh_key_id        = var.ssh_key_id
  additional_volume = var.additional_volume
  enable_polkashots = var.enable_polkashots
}
