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

variable "spokes-onprem-cidr" {
  default = "192.168.0.0/16"
}

variable "site-azure-cidr" {
  default = "172.31.0.0/16"
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

variable "location" {
  type    = string
  default = "francecentral"
}

// To use custom image 
// by default is false
variable "custom" {
  default = false
}

//  Custom image blob uri
variable "customuri" {
  type    = string
  default = "<custom image blob uri>"
}

variable "custom_image_name" {
  type    = string
  default = "<custom image name>"
}

variable "custom_image_resource_group_name" {
  type    = string
  default = "<custom image resource group>"
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

variable "fgt-bgp-asn" {
  type    = string
  default = "65001"
}

variable "sites-bgp-asn" {
  type    = string
  default = "65011"
}

variable "spokeacidr" {
  default = "172.31.32.0/23"
}

variable "spokeasubnetcidr" {
  default = "172.31.32.0/24"
}

variable "spokebcidr" {
  default = "172.31.48.0/23"
}

variable "spokebsubnetcidr" {
  default = "172.31.48.0/24"
}

variable "spokeccidr" {
  default = "172.31.50.0/23"
}

variable "spokecsubnetcidr" {
  default = "172.31.50.0/24"
}

variable "spokecsubnetrouteserver" {
  default = "172.31.51.0/24"
}

variable "vnetcidr" {
  default = "172.31.0.0/20"
}

variable "publiccidr" {
  default = "172.31.2.0/24"
}

variable "privatecidr" {
  default = "172.31.3.0/24"
}

variable "protectedacidr" {
  default = "172.31.10.0/24"
}

variable "advpncidr" {
  default = "172.31.4.0/24"
}

variable "mplscidr" {
  default = "172.31.5.0/24"
}

variable "hasynccidr" {
  default = "172.31.1.0/24"
}

variable "hamgmtcidr" {
  default = "172.31.1.0/24"
}

variable "activeport1" {
  default = "172.31.1.10"
}

variable "activeport1mask" {
  default = "255.255.255.0"
}

variable "activeport2" {
  default = "172.31.2.10"
}

variable "activeport2mask" {
  default = "255.255.255.0"
}

variable "activeport3" {
  default = "172.31.3.10"
}

variable "activeport3mask" {
  default = "255.255.255.0"
}

variable "activeport4" {
  default = "172.31.4.10"
}

variable "activeport4mask" {
  default = "255.255.255.0"
}

variable "passiveport1" {
  default = "172.31.1.11"
}

variable "passiveport1mask" {
  default = "255.255.255.0"
}

variable "passiveport2" {
  default = "172.31.2.11"
}

variable "passiveport2mask" {
  default = "255.255.255.0"
}

variable "passiveport3" {
  default = "172.31.3.11"
}

variable "passiveport3mask" {
  default = "255.255.255.0"
}

variable "passiveport4" {
  default = "172.31.4.11"
}

variable "passiveport4mask" {
  default = "255.255.255.0"
}

variable "port1gateway" {
  default = "172.31.1.1"
}

variable "port2gateway" {
  default = "172.31.2.1"
}

variable "port3gateway" {
  default = "172.31.3.1"
}

variable "port4gateway" {
  default = "172.31.4.1"
}

variable "bootstrap-active" {
  // Change to your own path
  type    = string
  default = "config-active.conf"
}

variable "bootstrap-passive" {
  // Change to your own path
  type    = string
  default = "config-passive.conf"
}

variable "bootstrap-site" {
  // Change to your own path
  type    = string
  default = "config-site.conf"
}

// license file for the active fgt
variable "license" {
  // Change to your own byol license file, license.lic
  type    = string
  default = "license.txt"
}

// license file for the passive fgt
variable "license2" {
  // Change to your own byol license file, license2.lic
  type    = string
  default = "license2.txt"
}

