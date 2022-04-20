# Site-to-Site VPN between Azure and AWS

This plan builds a site-to-site vpn connection using active active VPNs. The end result are four tunnels using IPSEC with BGP. This plan assumes you have already set up a TGW in the region you wish to establish connectivity with.

Currently requires manual interaction by checking "enable custom BGP address" under each of the VGN connections (4x) after applying the plan.
https://github.com/hashicorp/terraform-provider-azurerm/issues/15854

Plans included in this repository:

Microsoft Azure
1. Create a new Resource Group
2. Create two public IPs to be used for VGN
3. Create four Local Network Gateways
4. Create a transit VNET
5. Create a GatewaySubnet
6. Create a Virtual Network Gateway
7. Create four VPN connections

8. MANUAL STEP UNTIL FIXED: In each of the VPN connection configurations, check "Enable Custom BGP Addressess" and:

aws-vpn1-tun1: 169.254.21.2, 169.254.21.6
aws-vpn1-tun2: 169.254.22.2, 169,254,22,6
aws-vpn2-tun1: 169.254.21.2, 169.254.21.6
aws-vpn2-tun2: 169,254.22.2, 169.254.22.6


Amazon Web Services
1. Create a transit VPC
2. Create two customer gateways
3. Create a VPN gateway
4. Create two VPN connections and attach to existing TGW


## Getting Started

Enter your Microsoft Azure SP and information in terraform.tfvars. Terraform.tfvars.example can be used as an example. Execute code lke below.
````
terraform init
terraform plan
terraform apply
````

### Prerequisites

1. Microsoft Azure subscription
2. AWS subscription
3. TGW created within the AWS region you provided in the variables