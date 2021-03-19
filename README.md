# terraform-scaleway-polkadot

Terraform module to bootstrap ready-to-use _single node_ (or optionally _active-standby_) Kusama/Polkadot validators in DigitalOcean. Besides infrastructure (security group, instance, volume, etc), it also does:
- Pulls the latest snapshot from [Polkashots](https://polkashots.io)
- Creates a docker-compose with the [latest polkadot's release](https://github.com/paritytech/polkadot/releases) and nginx reverse-proxy (for libp2p port).

## Requirements

DigitalOcean token environment variable must be populated: 

```
export DIGITALOCEAN_TOKEN=XXXXXXXXXXX
```

More information within the [DigitalOcean Terraform Provider](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs)

## Usage

```hcl
module "validator" {
  source = "github.com/cloudstaking/terraform-digitalocean-polkadot?ref=1.1.0"

  chain = "kusama"

  droplet_name      = "validator"
  region            = "lon1"
  ssh_keys          = ["123456789"]
}
```

If `enable_polkashots` is set, it'll take ~10 minutes to download and extract the latest snapshot. You can check the process within the instance

```sh
$ tail -f  /var/log/cloud-init-output.log
4323850K .......... .......... .......... .......... .......... 99%  313M 0s
4323900K .......... ......                                     100% 56.2M=78s

2021-03-17 14:27:38 (54.2 MB/s) - ‘/srv/kusama.RocksDb.7z’ saved [4427690609/4427690609]

Scanning the drive for archives:
1 file, 4427690609 bytes (4223 MiB)

Extracting archive: kusama.RocksDb.7z
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| digitalocean | n/a |
| github | n/a |

## Modules

No Modules.

## Resources

| Name |
|------|
| [digitalocean_droplet](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/droplet) |
| [digitalocean_firewall](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/firewall) |
| [digitalocean_volume](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/volume) |
| [digitalocean_volume_attachment](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/volume_attachment) |
| [github_release](https://registry.terraform.io/providers/integrations/github/latest/docs/data-sources/release) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_volume | By default, s-4vcpu-8gb comes with 150GB disk size. Set this variable in order to create an additional volume (mounted in /srv) | `bool` | `false` | no |
| additional\_volume\_size | By default, s-4vcpu-8gb comes with 150GB disk size. If you want an additional volume under /srv | `number` | `200` | no |
| chain | Chain name: kusama or polkadot. Variable required to download the latest snapshot from polkashots.io | `string` | `"kusama"` | no |
| droplet\_name | Name of the instance/Droplet | `string` | `"validator"` | no |
| droplet\_size | Droplet size (type). For Kusama s-4vcpu-8gb should be fine. Check requirements in the Kusama/Polkadot wiki | `string` | `"s-4vcpu-8gb"` | no |
| enable\_docker\_compose | Application layer - create a docker-compose.yml (`/srv/docker-compose.yml`) with the latest polkadot version and nginx as a reverse-proxy | `bool` | `false` | no |
| enable\_firewall | If true, DigitalOcean firewall is enabled with some default rules | `bool` | `true` | no |
| enable\_polkashots | Pull latest Polkadot/Kusama (depending on chain variable) from polkashots.io | `bool` | `true` | no |
| firewall\_name | Firewall name (some cloud providers call this "security group") | `string` | `"validator"` | no |
| firewall\_whitelisted\_ssh\_ip | List of CIDRs the instance is going to accept SSH connections from | `list` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| polkadot\_additional\_common\_flags | Application layer - when `enable_docker_compose = true`, the content of this variable will be appended to the polkadot command arguments | `string` | `""` | no |
| region | Droplet region | `any` | n/a | yes |
| ssh\_keys | A list of SSH IDs, use [DigitalOcean API](https://developers.digitalocean.com/documentation/v2/#ssh-keys) to get the IDs. You can also reset the password from the DigitalOcean console. | `list` | `[]` | no |
| tags | Tags for the instance | `list` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| validator\_public\_ip | Validator public IP address, you can use it to SSH into it |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
