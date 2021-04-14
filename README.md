# terraform-digitalocean-polkadot

Terraform module to bootstrap ready-to-use _single node_ (or optionally _active-standby_) Kusama/Polkadot validators in GCP. Besides infrastructure components (security group, instance, volume, etc), it also:

- Optionally pulls latest snapshot from [Polkashots](https://polkashots.io)
- [Node exporter](https://github.com/prometheus/node_exporter) with HTTPs to securly pull metrics from your monitoring systems.
- Nginx as a reverse proxy for libp2p
- Support for different deplotments methods: either using docker/docker-compose or deploying the binary itself in the host.

It uses the latest official Ubuntu 20.04 LTS (no custom image).

## Requirements

DigitalOcean token environment variable must be populated: 

```
export DIGITALOCEAN_TOKEN=XXXXXXXXXXX
```

More information within the [DigitalOcean Terraform Provider](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs)

## Usage

```hcl
module "validator" {
  source = "github.com/cloudstaking/terraform-digitalocean-polkadot?ref=1.2.0"

  chain = "kusama"

  droplet_name      = "validator"
  region            = "lon1"
  ssh_keys          = ["123456789"]
}
```

If `enable_polkashots` is set, it'll take ~10 minutes to download and extract the latest snapshot. You can check the process within the instance with `tail -f  /var/log/cloud-init-output.log`

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Providers

| Name | Version |
|------|---------|
| digitalocean | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| cloud_init | /home/mogaal/workspace/github/cloudstaking/terraform-cloudinit-polkadot |  |

## Resources

| Name |
|------|
| [digitalocean_droplet](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/droplet) |
| [digitalocean_firewall](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/firewall) |
| [digitalocean_ssh_key](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/ssh_key) |
| [digitalocean_volume](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/volume) |
| [digitalocean_volume_attachment](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/volume_attachment) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| region | Droplet region | `string` | n/a | yes |
| application\_layer | You can deploy the Polkadot using docker containers or in the host itself (using the binary) | `string` | `"host"` | no |
| chain | Chain name: kusama or polkadot. Variable required to download the latest snapshot from polkashots.io | `string` | `"kusama"` | no |
| disk\_size | Disk size. Disk size. Volume is created and mounted under /home | `number` | `200` | no |
| droplet\_name | Name of the instance/Droplet | `string` | `"validator"` | no |
| droplet\_size | Droplet size (type). For Kusama `s-4vcpu-8gb` should be fine, for Polkadot maybe `m3-8vcpu-64gb`. This constantly change, check requirements section in the Polkadot wiki | `string` | `"s-4vcpu-8gb"` | no |
| enable\_polkashots | Pull latest Polkadot/Kusama (depending on chain variable) from polkashots.io | `bool` | `false` | no |
| firewall\_name | Firewall name | `string` | `""` | no |
| http\_password | Password to access endpoints (e.g node\_exporter) | `string` | `""` | no |
| http\_username | Username to access endpoints (e.g node\_exporter) | `string` | `""` | no |
| p2p\_port | P2P port for Polkadot service, used in `--listen-addr` args | `number` | `30333` | no |
| polkadot\_additional\_common\_flags | CLI arguments appended to the polkadot service (e.g validator name) | `string` | `""` | no |
| proxy\_port | nginx reverse-proxy port to expose Polkadot's libp2p port. Polkadot's libp2p port should not be exposed directly for security reasons (DOS) | `number` | `80` | no |
| public\_fqdn | Public domain for validator. If set, Caddy will use it to request LetsEncrypt certs. This variable is particulary useful to provide a secure channel (HTTPs) for [node\_exporter](https://github.com/prometheus/node_exporter) | `string` | `""` | no |
| ssh\_key | SSH Key to use for the droplet | `string` | `""` | no |
| ssh\_key\_id | DigitalOcean doesn't allow duplicate keys. If your SSH public key already exist provide its ID in this variable. Use [DigitalOcean API](https://developers.digitalocean.com/documentation/v2/#ssh-keys) to get the IDs. | `string` | `""` | no |
| tags | Tags for the instance | `list(any)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| http\_password | Password to access private endpoints (e.g node\_exporter) |
| http\_username | Username to access private endpoints (e.g node\_exporter) |
| validator\_public\_ip | Validator public IP address, you can use it to SSH into it |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
