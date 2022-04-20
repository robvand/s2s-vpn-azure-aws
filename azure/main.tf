provider "azurerm" {
  features {}
  subscription_id = var.az_subscription_id
  client_secret   = var.az_client_secret
  tenant_id       = var.az_tenant_id
  client_id       = var.az_client_id
}

# Create a RG
resource "azurerm_resource_group" "rg1" {
  name     = var.az_rg
  location = var.az_location
}

# Create 2 PIPs
resource "azurerm_public_ip" "pip1" {
  name                = "S2S-PIP1"
  resource_group_name = azurerm_resource_group.rg1.name
  location            = azurerm_resource_group.rg1.location
  sku                 = "Standard"
  allocation_method   = "Static"
  zones               = [1,2,3]
  tags = {
    createdby = "Terraform"
  }
}

resource "azurerm_public_ip" "pip2" {
  name                = "S2S-PIP2"
  resource_group_name = azurerm_resource_group.rg1.name
  location            = azurerm_resource_group.rg1.location
  sku                 = "Standard"
  allocation_method   = "Static"
  zones               = [1,2,3]
  tags = {
    createdby = "Terraform"
  }
}

##### VALIDATE IF SPLIT NEEDED

# Create LNGs
resource "azurerm_local_network_gateway" "aws-vpn1-tun1" {
  name                = "aws-vpn1-tun1"
  resource_group_name = azurerm_resource_group.rg1.name
  location            = azurerm_resource_group.rg1.location
  gateway_address     = var.vpn_1_tun_1
  bgp_settings {
    asn = "64512"
    bgp_peering_address = "169.254.21.1"
  }
}

resource "azurerm_local_network_gateway" "aws-vpn1-tun2" {
  name                = "aws-vpn1-tun2"
  resource_group_name = azurerm_resource_group.rg1.name
  location            = azurerm_resource_group.rg1.location
  gateway_address     = var.vpn_1_tun_2
  bgp_settings {
    asn = "64512"
    bgp_peering_address = "169.254.22.1"
  }
}

resource "azurerm_local_network_gateway" "aws-vpn2-tun1" {
  name                = "aws-vpn2-tun1"
  resource_group_name = azurerm_resource_group.rg1.name
  location            = azurerm_resource_group.rg1.location
  gateway_address     = var.vpn_2_tun_1
  bgp_settings {
    asn = "64512"
    bgp_peering_address = "169.254.21.5"
  }
}

resource "azurerm_local_network_gateway" "aws-vpn2-tun2" {
  name                = "aws-vpn2-tun2"
  resource_group_name = azurerm_resource_group.rg1.name
  location            = azurerm_resource_group.rg1.location
  gateway_address     = var.vpn_2_tun_2
  bgp_settings {
    asn = "64512"
    bgp_peering_address = "169.254.22.5"
  }
}

# Create a VNET for transit
resource "azurerm_virtual_network" "vnet_transit" {
  name                = "s2s-transit-vnet"
  resource_group_name = azurerm_resource_group.rg1.name
  location            = azurerm_resource_group.rg1.location
  address_space       = ["10.199.0.0/16"]
}

# Create a GatewaySubnet
resource "azurerm_subnet" "gw-subnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.vnet_transit.name
  address_prefixes     = ["10.199.0.0/24"]
}

# Create the Virtual Network Gateway
resource "azurerm_virtual_network_gateway" "vgn1" {
  name                = "s2s-aws-vgn"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = true
  enable_bgp    = true
  sku           = "VpnGw2AZ"
  
  bgp_settings {
    asn         = "64513"
    peering_addresses {
      ip_configuration_name = "vnetGatewayConfig1"
      apipa_addresses = ["169.254.21.2","169.254.22.2"]
    }
    peering_addresses {
      ip_configuration_name = "vnetGatewayConfig2"
      apipa_addresses = ["169.254.21.6","169.254.22.6"]
    }
  }

  ip_configuration {
    name = "vnetGatewayConfig1"
    public_ip_address_id = azurerm_public_ip.pip1.id
    subnet_id = azurerm_subnet.gw-subnet.id
  }

  ip_configuration {
    name = "vnetGatewayConfig2"
    public_ip_address_id = azurerm_public_ip.pip2.id
    subnet_id = azurerm_subnet.gw-subnet.id
  }
}

# Create the VPN connections
resource "azurerm_virtual_network_gateway_connection" "aws-vpn1-tun1" {
  name                          = "aws-vpn1-tun1"
  location                      = azurerm_resource_group.rg1.location
  resource_group_name           = azurerm_resource_group.rg1.name
  type                          = "IPsec"
  virtual_network_gateway_id    = azurerm_virtual_network_gateway.vgn1.id
  local_network_gateway_id      = azurerm_local_network_gateway.aws-vpn1-tun1.id
  shared_key                    = var.preshared_key
  enable_bgp                    = true
}

resource "azurerm_virtual_network_gateway_connection" "aws-vpn1-tun2" {
  name                          = "aws-vpn1-tun2"
  location                      = azurerm_resource_group.rg1.location
  resource_group_name           = azurerm_resource_group.rg1.name
  type                          = "IPsec"
  virtual_network_gateway_id    = azurerm_virtual_network_gateway.vgn1.id
  local_network_gateway_id      = azurerm_local_network_gateway.aws-vpn1-tun2.id
  shared_key                    = var.preshared_key
  enable_bgp                    = true
}

resource "azurerm_virtual_network_gateway_connection" "aws-vpn2-tun1" {
  name                          = "aws-vpn2-tun1"
  location                      = azurerm_resource_group.rg1.location
  resource_group_name           = azurerm_resource_group.rg1.name
  type                          = "IPsec"
  virtual_network_gateway_id    = azurerm_virtual_network_gateway.vgn1.id
  local_network_gateway_id      = azurerm_local_network_gateway.aws-vpn2-tun1.id
  shared_key                    = var.preshared_key
  enable_bgp                    = true
}

resource "azurerm_virtual_network_gateway_connection" "aws-vpn2-tun2" {
  name                          = "aws-vpn2-tun2"
  location                      = azurerm_resource_group.rg1.location
  resource_group_name           = azurerm_resource_group.rg1.name
  type                          = "IPsec"
  virtual_network_gateway_id    = azurerm_virtual_network_gateway.vgn1.id
  local_network_gateway_id      = azurerm_local_network_gateway.aws-vpn2-tun2.id
  shared_key                    = var.preshared_key
  enable_bgp                    = true
}

