locals {
  chain = {
    kusama   = { name = "kusama", short = "ksm" },
    polkadot = { name = "polkadot", short = "dot" }
    other    = { name = var.chain, short = var.chain }
  }

  docker_compose = templatefile("${path.module}/templates/generate-docker-compose.sh.tpl", {
    chain                   = var.chain
    enable_polkashots       = var.enable_polkashots
    latest_version          = data.github_release.polkadot.release_tag
    additional_common_flags = var.polkadot_additional_common_flags
  })

  cloud_init = templatefile("${path.module}/templates/cloud-init.yaml.tpl", {
    chain             = lookup(local.chain, var.chain, local.chain.other)
    enable_polkashots = var.enable_polkashots
    additional_volume = var.additional_volume
    docker_compose    = var.enable_docker_compose ? base64encode(local.docker_compose) : ""
    nginx_config      = base64encode(file("${path.module}/templates/nginx.conf.tpl"))
  })
}

resource "digitalocean_droplet" "validator" {
  image     = "ubuntu-20-04-x64"
  name      = var.droplet_name
  region    = var.region
  size      = var.droplet_size
  ssh_keys  = var.ssh_keys
  tags      = var.tags
  user_data = local.cloud_init
}

resource "digitalocean_firewall" "web" {
  count = var.enable_firewall ? 1 : 0

  name        = var.firewall_name
  droplet_ids = [digitalocean_droplet.validator.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = var.firewall_whitelisted_ssh_ip
  }

  # nginx (reverse-proxy for p2p)
  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}

resource "digitalocean_volume" "validator" {
  count = var.additional_volume ? 1 : 0

  region                  = var.region
  name                    = var.droplet_name
  size                    = var.additional_volume_size
  description             = "Extra-volume for Polkadot/Kusama validator"
}

resource "digitalocean_volume_attachment" "validator" {
  count = var.additional_volume ? 1 : 0

  droplet_id = digitalocean_droplet.validator.id
  volume_id  = digitalocean_volume.validator.0.id
}

data "github_release" "polkadot" {
  repository  = "polkadot"
  owner       = "paritytech"
  retrieve_by = "latest"
}
