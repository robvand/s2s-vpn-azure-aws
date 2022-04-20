##############################################
# TF ROOT PLAN
##############################################

module "aws" {
  source             = "./aws"
  aws_region         = var.aws_region
  aws_access_key     = var.aws_access_key
  aws_secret_key     = var.aws_secret_key
  az_pip1            = module.azure.az_pip1
  az_pip2            = module.azure.az_pip2
  preshared_key      = var.preshared_key
  tgw_id             = var.tgw_id
 }

module "azure" {
  source                = "./azure"
  az_location           = var.az_location
  az_client_secret      = var.az_client_secret
  az_client_id          = var.az_client_id
  az_subscription_id    = var.az_subscription_id
  az_tenant_id          = var.az_tenant_id
  az_rg                 = var.az_rg
  vpn_1_tun_1           = module.aws.vpn_1_tun_1
  vpn_1_tun_2           = module.aws.vpn_1_tun_2
  vpn_2_tun_1           = module.aws.vpn_2_tun_1
  vpn_2_tun_2           = module.aws.vpn_2_tun_2
  preshared_key         = var.preshared_key
 }


