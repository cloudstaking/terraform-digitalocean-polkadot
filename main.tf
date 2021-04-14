locals {
  firewall_name = var.firewall_name != "" ? var.firewall_name : "${var.droplet_name}-sg"

  disk_size = {
    additional_volume      = var.disk_size >= 40 ? true : false
    additional_volume_size = var.disk_size
  }
}

resource "digitalocean_ssh_key" "validator" {
  count = var.ssh_key_id != "" ? 0 : 1

  name       = "${var.droplet_name}-key"
  public_key = var.ssh_key
}

resource "digitalocean_droplet" "validator" {
  image     = "ubuntu-20-04-x64"
  name      = var.droplet_name
  region    = var.region
  size      = var.droplet_size
  ssh_keys  = [var.ssh_key_id != "" ? var.ssh_key_id : digitalocean_ssh_key.validator.0.id]
  user_data = module.cloud_init.clout_init
  tags      = var.tags

  depends_on = [digitalocean_volume.validator]
}

resource "digitalocean_firewall" "web" {
  name        = local.firewall_name
  droplet_ids = [digitalocean_droplet.validator.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  # nginx (reverse-proxy for p2p)
  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  # node_exporter
  inbound_rule {
    protocol         = "tcp"
    port_range       = "9100"
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
  count = local.disk_size.additional_volume ? 1 : 0

  region      = var.region
  name        = var.droplet_name
  size        = local.disk_size.additional_volume_size
  description = "Extra-volume for Polkadot/Kusama validator"
}

resource "digitalocean_volume_attachment" "validator" {
  count = local.disk_size.additional_volume ? 1 : 0

  droplet_id = digitalocean_droplet.validator.id
  volume_id  = digitalocean_volume.validator.0.id
}

module "cloud_init" {
  # source = "github.com/cloudstaking/terraform-cloudinit-polkadot?ref=main"
  source = "/home/mogaal/workspace/github/cloudstaking/terraform-cloudinit-polkadot"

  application_layer                = var.application_layer
  additional_volume                = local.disk_size.additional_volume
  cloud_provider                   = "digitalocean"
  chain                            = var.chain
  polkadot_additional_common_flags = var.polkadot_additional_common_flags
  enable_polkashots                = var.enable_polkashots
  p2p_port                         = var.p2p_port
  proxy_port                       = var.proxy_port
  public_fqdn                      = var.public_fqdn
  http_username                    = var.http_username
  http_password                    = var.http_password
}
