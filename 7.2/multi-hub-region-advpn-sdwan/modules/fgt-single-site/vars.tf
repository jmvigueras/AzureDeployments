variable "storage-account_endpoint" {}
variable "resourcegroup_name" {}

# Azure resourcers prefix description
variable "prefix" {
  type    = string
  default = "terraform"
}

variable "site-id" {
  type    = string
  default = "1"
}

variable "zone-id" {
  type    = string
  default = "zA"
}

//  For HA, choose instance size that support 4 nics at least
//  Check : https://docs.microsoft.com/en-us/azure/virtual-machines/linux/sizes
variable "size" {
  type    = string
  default = "Standard_F4"
}

variable "location" {
  type    = string
  default = "francecentral"
}

variable "fgt-ni_ids" {
  type = list(string)
  default = ["ni-port1_id", "ni-port2_id", "ni-port3_id", "ni-port4_id"]
}

variable "fgt-ni-nsg_ids"{
  type = list(string)
  default = ["nsg-mgmt-ha_id", "nsg-public_id", "nsg-private_id"]
}

variable "subnets-vnet-fgt_nets" {
  type = map(any)
  default = {
    "mgmt" = "172.31.1.0/24"
    "public" = "172.31.2.0/24"
    "private" = "172.31.3.0/24"
  }
}

variable "subnets-site-peer" {
  type = map(any)
  default = {
    "1_name" = "vnet-site-spoke1"
    "1_net"  = "192.168.10.0/24"
  }
}

variable "hub-advpn-ips" {
  type = map(any)
  default = {
    "huba-advpn-public-ip"  = "0.0.0.0/0"
    "hubb-advpn-public-ip"  = "0.0.0.0/0"
    "huba-advpn-mpls-ip_1"  = "172.31.4.10"
    "huba-advpn-mpls-ip_2"  = "172.31.4.11"
    "huba-mpls-local-1"     = "10.10.20.1"
    "huba-mpls-local-2"     = "10.10.20.2"
    "huba-mpls-remote"      = "10.10.20.254"
    "huba-public-local"     = "10.10.10.1"
    "huba-public-remote"    = "10.10.10.254"
    "hubb-public-local"     = "10.10.10.2"
    "hubb-public-remote"    = "10.10.10.253"
  }
}

variable "healthcheck-srv" {
  type = map(any)
  default = {
    "healthcheck-huba-srv-1"  = "172.31.32.4"
    "healthcheck-huba-srv-2"  = "172.31.34.4"
    "healthcheck-hubb-srv-1"  = "172.31.48.4"
  }
}

variable "rt-private_name" {
  type    = string
  default = "rt-private"
}

variable "rt-spoke_name" {
  type    = string
  default = "rt-spoke"
}

variable "spokes-onprem-cidr" {
  default = "192.168.0.0/16"
}

variable "n-azure-hubs-cidr" {
  default = "172.31.0.0/16"
}

variable "n-azure-hub1-cidr"{
  default = "172.31.32.0/22"
}

variable "n-azure-hub2-cidr"{
  default = "172.31.48.0/22"
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


