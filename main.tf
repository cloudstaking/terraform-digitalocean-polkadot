locals {
  kusama   = { name = "kusama", short = "ksm" }
  polkadot = { name = "polkadot", short = "dot" }
}

resource "digitalocean_droplet" "validator" {
  image    = var.droplet_image
  name     = var.droplet_name
  region   = var.region
  size     = var.droplet_size
  ssh_keys = var.ssh_keys

  user_data = templatefile("${path.module}/templates/cloud-init.yaml.tpl", {
    chain             = var.chain == "kusama" ? local.kusama : local.polkadot
    enable_polkashots = var.enable_polkashots
    additional_volume = var.additional_volume
  })
}

resource "digitalocean_firewall" "web" {
  count = var.enable_firewall ? 1 : 0

  name        = var.firewall_name
  droplet_ids = [digitalocean_droplet.validator.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = var.firewall_whitelist_ip_ssh
  }

  # libp2p port
  inbound_rule {
    protocol         = "tcp"
    port_range       = "30333"
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
  initial_filesystem_type = "ext4"
  description             = "Extra-volume for Polkadot/Kusama validator"
}

resource "digitalocean_volume_attachment" "validator" {
  count = var.additional_volume ? 1 : 0

  droplet_id = digitalocean_droplet.validator.id
  volume_id  = digitalocean_volume.validator.0.id
}

