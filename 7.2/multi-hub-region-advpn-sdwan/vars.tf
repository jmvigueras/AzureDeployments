// Azure configuration
variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

# GCP resourcers prefix description
variable "prefix" {
  type    = string
  default = "terraform"
}

// ADVPN PSK IPSEC 
variable "advpn-ipsec-psk" {
  default = "sample-password"
}

// S2S PSK IPSEC 
variable "s2s-ipsec-psk" {
  default = "sample-password"
}

# Azure resourcers prefix description
variable "tag_env" {
  type    = string
  default = "terraform-deploy"
}

//  For HA, choose instance size that support 4 nics at least
//  Check : https://docs.microsoft.com/en-us/azure/virtual-machines/linux/sizes
variable "size" {
  type    = string
  default = "Standard_F4"
}

variable "size-vm" {
  type    = string
  default = "Standard_B1ls"
}

variable "regiona" {
  type    = string
  default = "francecentral"
}

variable "regionb" {
  type    = string
  default = "eastus2"
}

// License Type to create FortiGate-VM
// Provide the license type for FortiGate-VM Instances, either byol or payg.
variable "license_type" {
  default = "payg"
}

// enable accelerate network, either true or false, default is false
// Make the the instance choosed supports accelerated networking.
// Check: https://docs.microsoft.com/en-us/azure/virtual-network/accelerated-networking-overview#supported-vm-instances
variable "accelerate" {
  default = "false"
}

variable "publisher" {
  type    = string
  default = "fortinet"
}

variable "fgtoffer" {
  type    = string
  default = "fortinet_fortigate-vm_v5"
}

// BYOL sku: fortinet_fg-vm
// PAYG sku: fortinet_fg-vm_payg_2022
variable "fgtsku" {
  type = map(any)
  default = {
    byol = "fortinet_fg-vm"
    payg = "fortinet_fg-vm_payg_2022"
  }
}

// FOS version
variable "fgtversion" {
  type    = string
  default = "7.2.0"
}

variable "adminusername" {
  type    = string
  default = "azureadmin"
}

variable "adminpassword" {
  type    = string
  default = "Terraform123#"
}

// HTTPS Port
variable "adminsport" {
  type    = string
  default = "8443"
}

variable "adminscidr" {
  type    = string
  default = "0.0.0.0/0"
}

variable "za-fgt-bgp-asn" {
  type    = string
  default = "65001"
}

variable "zb-fgt-bgp-asn" {
  type    = string
  default = "65002"
}

variable "sites-bgp-asn" {
  type    = string
  default = "65011"
}

variable "spokes-onprem-cidr" {
  default = "192.168.0.0/16"
}

variable "site-azure-cidr" {
  default = "172.31.0.0/16"
}

// CDIR range /20 for VNET FGT in region A
variable "vnet-fgt-cidr-regiona" {
  default = "172.31.0.0/20"
}

// CDIR range /20 for VNET FGT in region B
variable "vnet-fgt-cidr-regionb" {
  default = "172.31.16.0/20"
}

// CDIR range /23 for VNET SpokeA in region A
variable "vnet-spokea-cidr-regiona" {
  default = "172.31.32.0/23"
}

// CDIR range /23 for VNET SpokeB in region A
variable "vnet-spokeb-cidr-regiona" {
  default = "172.31.34.0/23"
}

// CDIR range /23 for VNET SpokeC in region B
variable "vnet-spokec-cidr-regionb" {
  default = "172.31.48.0/23"
}

// CDIR range /23 for VNET SpokeD in region B
variable "vnet-spoked-cidr-regionb" {
  default = "172.31.50.0/23"
}

variable "bootstrap-active" {
  // Change to your own path
  type    = string
  default = "./templates/config-active.conf"
}

variable "bootstrap-passive" {
  // Change to your own path
  type    = string
  default = "./templates/config-passive.conf"
}

// license file for the active fgt
variable "license-active" {
  // Change to your own byol license file, license.lic
  type    = string
  default = "./licenses/license-active.txt"
}

// license file for the passive fgt
variable "license-passive" {
  // Change to your own byol license file, license2.lic
  type    = string
  default = "./licenses/license-passive.txt"
}

variable "bootstrap-site" {
  // Change to your own path
  type    = string
  default = "./templates/config-site.conf"
}

// license file for the active fgt
variable "license" {
  // Change to your own byol license file, license.lic
  type    = string
  default = "./licenses/license-site.txt"
}


