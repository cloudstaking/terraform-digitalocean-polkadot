
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
  enable_polkashots = true

  polkadot_additional_common_flags = "--name=CLOUDSTAKING-BLUE --telemetry-url 'wss://telemetry.polkadot.io/submit/ 1'"
}
