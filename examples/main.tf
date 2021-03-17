
terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
    }
  }
  required_version = ">= 0.13"
}

# Provider(s)
provider "digitalocean" {}

module "validator" {
  source = "../"

  chain = "kusama"

  droplet_name      = "validator"
  region            = "lon1"
  ssh_keys          = ["29821896"]
  additional_volume = false
}
