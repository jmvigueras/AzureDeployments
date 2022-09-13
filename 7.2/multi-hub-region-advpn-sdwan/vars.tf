// Azure configuration
variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

# Azure resourcers prefix description
variable "prefix" {
  type    = string
  default = "terraform"
}

// ADVPN PSK IPSEC Fortinet
variable "advpn-ipsec-psk" {
  default = "sample-password"
}

// S2S PSK IPSEC Virtual Network Gateways (MPLS simulation)
variable "s2s-ipsec-psk" {
  default = "sample-password"
}

# Azure resourcers tag
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

//For testing VMs
variable "size-vm" {
  type    = string
  default = "Standard_B1ls"
}

//Region for HUB A deployment
variable "regiona" {
  type    = string
  default = "francecentral"
}

//Region for HUB B deployment
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

// BGP ASN for FGT cluster in Region A
variable "za-fgt-bgp-asn" {
  type    = string
  default = "65001"
}

// BGP ASN for FGT cluster in Region B
variable "zb-fgt-bgp-asn" {
  type    = string
  default = "65002"
}

// BGP ASN for sites
variable "sites-bgp-asn" {
  type    = string
  default = "65011"
}

// CIDR range for entire network sites
variable "spokes-onprem-cidr" {
  default = "192.168.0.0/16"
}

// CIDR range for entire network on azure
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

// CDIR agretate range SpokeA and B in region A
variable "vnet-spokes-cidr-regiona" {
  default = "172.31.32.0/22"
}

// CDIR agretate range SpokeC and D in region B
variable "vnet-spokes-cidr-regionb" {
  default = "172.31.48.0/22"
}

// Config template for active fortigate member in cluster
variable "bootstrap-active" {
  // Change to your own path
  type    = string
  default = "./templates/config-active.conf"
}

// Config template for passive fortigate member in cluster
variable "bootstrap-passive" {
  // Change to your own path
  type    = string
  default = "./templates/config-passive.conf"
}

// license file for the active fgt in Region A
variable "za-license-active" {
  // Change to your own byol license file, license.lic
  type    = string
  default = "./licenses/za-license-active.txt"
}

// license file for the passive fgt in Region A
variable "za-license-passive" {
  // Change to your own byol license file, license2.lic
  type    = string
  default = "./licenses/za-license-passive.txt"
}

// license file for the active fgt in Region B
variable "zb-license-active" {
  // Change to your own byol license file, license.lic
  type    = string
  default = "./licenses/zb-license-active.txt"
}

// license file for the passive fgt in Region b
variable "zb-license-passive" {
  // Change to your own byol license file, license2.lic
  type    = string
  default = "./licenses/zb-license-passive.txt"
}

variable "bootstrap-site" {
  // Change to your own path
  type    = string
  default = "./templates/config-site.conf"
}

// license file for the active fgt
variable "license-site" {
  // Change to your own byol license file, license.lic
  type    = string
  default = "./licenses/license-site.txt"
}


