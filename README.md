# terraform-scaleway-polkadot

Terraform module to bootstrap ready-to-use _single node_ (or optionally _active-standby_) Kusama/Polkadot validators in DigitalOcean. It creates firewall, optional droplet volume and finally ensure the latest snapshot from [Polkashots](https://polkashots.io) is pulled.

## Requirements

It requires to have DigitalOcean account with the token variable exported. 

```
export DIGITALOCEAN_TOKEN=XXXXXXXXXXX
```

More information within the [DigitalOcean Terraform Provider](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs)

## Usage

```hcl
module "validator" {
  source = "github.com/cloudstaking/terraform-digitalocean-polkadot?ref=1.0.0"

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


#### Providers

| Name | Version |
|------|---------|
| digitalocean | n/a |

#### Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| region | Droplet region | `any` | n/a |
| additional_volume | By default, s-4vcpu-8gb comes with 150GB disk size. Set to true to create an additional volume and mount it under /srv | `bool` | `false` |
| additional_volume_size | By default, s-4vcpu-8gb comes with 150GB disk size. If you want an additional volume under /srv | `number` | `10` |
| chain | Which chain you are using: kusama or polkadot. It is used to download the latest snapshot from polkashots.io | `string` | `"kusama"` |
| droplet_image | Droplet image | `string` | `"debian-10-x64"` |
| droplet_name | Name of the Droplet | `string` | `"validator"` |
| droplet_size | Droplet size (type). For Kusama s-4vcpu-8gb is fine | `string` | `"s-4vcpu-8gb"` |
| enable_firewall | If true, DigitalOcean firewall is enabled with some default rules | `bool` | `true` |
| enable_polkashots | Pull the latest Polkadot/Kusama (depending on chain variable) from polkashots.io | `bool` | `true` |
| firewall_name | Firewall name (some cloud providers call this "security group") | `string` | `"validator"` |
| firewall_whitelist_ip_ssh | List of CIDRs that droplet is going to accept SSH connections from | `list` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> |
| ssh_keys | A list of SSH IDs, use [DigitalOcean API](https://developers.digitalocean.com/documentation/v2/#ssh-keys) to get the IDs. You can also reset the password from the DigitalOcean console. | `list` | `[]` |

#### Outputs

| Name | Description |
|------|-------------|
| validator_public_ip | Validator public IP address, you can use it to SSH into it |


