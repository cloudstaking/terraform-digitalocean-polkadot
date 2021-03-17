# terraform-scaleway-polkadot

Terraform module to bootstrap DigitalOcean droplets ready-to-use for Kusama/Polkadot validators. It creates firewall, optional droplet volume and finally ensure the latest snapshot from [Polkashots](https://polkashots.io) is pulled.

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


