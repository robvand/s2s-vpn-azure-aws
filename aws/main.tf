provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

# Create a VPC
resource "aws_vpc" "transit_vpc" {
  cidr_block = "10.99.0.0/16"
  tags = {
    Name = "s2s-transit-vpc"
  }
}

# Create customer gateways
resource "aws_customer_gateway" "cgw1" {
  bgp_asn    = 64513
  ip_address = var.az_pip1
  type       = "ipsec.1"

  tags = {
    Name = "s2s-azure-cgw1"
  }
}

resource "aws_customer_gateway" "cgw2" {
  bgp_asn    = 64513
  ip_address = var.az_pip2
  type       = "ipsec.1"

  tags = {
    Name = "s2s-azure-cgw2"
  }
}

# Create VPN gateways
resource "aws_vpn_gateway" "vpn_gw1" {
  vpc_id = aws_vpc.transit_vpc.id

  tags = {
    Name = "s2s-azure-vgw1"
  }
}

# Create VPN connections
resource "aws_vpn_connection" "s2s-to-azure-1" {
  customer_gateway_id = aws_customer_gateway.cgw1.id
  type                = "ipsec.1"
  tunnel1_inside_cidr = "169.254.21.0/30"
  tunnel2_inside_cidr = "169.254.22.0/30"
  tunnel1_preshared_key = var.preshared_key
  tunnel2_preshared_key = var.preshared_key
  transit_gateway_id = var.tgw_id
  
  tags = {
    Name = "s2s-azure-vpn-1"
  }
}

resource "aws_vpn_connection" "s2s-to-azure-2" {
  customer_gateway_id = aws_customer_gateway.cgw2.id
  type                = "ipsec.1"
  tunnel1_inside_cidr = "169.254.21.4/30"
  tunnel2_inside_cidr = "169.254.22.4/30"
  tunnel1_preshared_key = var.preshared_key
  tunnel2_preshared_key = var.preshared_key
  transit_gateway_id = var.tgw_id

  tags = {
    Name = "s2s-azure-vpn-2"
  }
}