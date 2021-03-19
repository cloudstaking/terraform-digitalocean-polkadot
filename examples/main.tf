
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
  source = "../"

  chain = "kusama"

  droplet_name          = "validator"
  region                = "lon1"
  ssh_keys              = ["29821896"]
  additional_volume     = true
  enable_docker_compose = true
  enable_polkashots     = true

  polkadot_additional_common_flags = "--name=alejandro --telemetry-url 'wss://telemetry.polkadot.io/submit/ 1'"
}
