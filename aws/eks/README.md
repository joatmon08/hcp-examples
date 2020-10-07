# HCP Consul with AWS EKS

## Prerequisites

1. Terraform Cloud as Backend, state only (or reconfigure `terraform` directive in `providers.tf`)
1. AWS Account
1. HCP Consul (already set up with HVN + Cluster) - you will need the `client_config.json` and `ca.pem` copied to the `secrets` folder.
1. HCP Consul bootstrap token, set as `export CONSUL_HTTP_TOKEN=<bootstrap token>`
1. `jq` installed

## Usage

1. Run `make consul-config`. This extracts the gossip key and host to create variable files.
   It also copies the `${CONSUL_HTTP_TOKEN}` environment variable into `secrets/token`.
1. Run `terraform init` and `terraform apply`. It will stop with an error.
1. Set up the peering connection in HVN (do not accept, this configuration will do it for you).
1. Set `peering_connection_has_been_added_to_hvn = true`. This executes the HVN/HCP module to
   accept the peering connection and add the security groups for HCP Consul.
1. Run `make consul` to install the Helm chart to your EKS cluster.