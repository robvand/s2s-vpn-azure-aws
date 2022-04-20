##############################################
# Common variables
##############################################

variable "preshared_key" {
  description = "preshared key for ipsec"
}

##############################################
# Azure variables
##############################################

variable "az_location" {
  description = "the Azure region where the S2S VPN should be established"
}
variable "az_client_secret" {
  description = "Azure client secret"
}
variable "az_client_id" {
  description = "Azure client ID"
}
variable "az_subscription_id" {
  description = "Azure subscription ID"
}
variable "az_tenant_id" {
  description = "Azure tenant ID"
}
variable "az_rg" {
  description = "Azure Resource Group"
  default = "TF-S2S"
}

##############################################
# AWS variables
##############################################

variable "aws_region" {
  description = "The AWS region where the S2S VPN should be established"
}
variable "aws_access_key" {
  description = "AWS access key"
}
variable "aws_secret_key" {
  description = "AWS secret key"
}
variable "tgw_id" {
  description = "AWS TGW that the s2s connection will use"
}


