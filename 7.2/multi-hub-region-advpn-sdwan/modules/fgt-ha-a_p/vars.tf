// Azure configuration
variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

variable "storage-account_endpoint" {}
variable "resourcegroup_name" {}

variable "adminusername" {}
variable "adminpassword" {}

// HTTPS Port
variable "adminsport" {
  type    = string
  default = "8443"
}

variable "adminscidr" {
  type    = string
  default = "0.0.0.0/0"
}

# Azure resourcers prefix description
variable "prefix" {
  type    = string
  default = "terraform"
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

variable "fgt-active-ni_ids" {
  type = list(string)
  default = ["ni-port1_id", "ni-port2_id", "ni-port3_id", "ni-port4_id"]
}

variable "fgt-active-ni_names" {
  type = list(string)
  default = ["ni-port1_name", "ni-port2_name", "ni-port3_name", "ni-port4_name"]
}

variable "fgt-passive-ni_ids" {
  type = list(string)
  default = ["ni-port1_id", "ni-port2_id", "ni-port3_id", "ni-port4_id"]
}

variable "fgt-passive-ni_names" {
  type = list(string)
  default = ["ni-port1_name", "ni-port2_name", "ni-port3_name", "ni-port4_name"]
}

variable "fgt-ni-nsg_ids"{
  type = list(string)
  default = ["nsg-mgmt-ha_id", "nsg-public_id", "nsg-private_id", "nsg-private_id"]
}

variable "subnets-vnet-fgt_nets" {
  type = map(any)
  default = {
    "mgmt" = "172.31.1.0/24"
    "public" = "172.31.2.0/24"
    "internal" = "172.31.3.0/24"
    "advpn" = "172.31.4.0/24"
  }
}

variable "vnets-spoke-peer" {
  type = map(any)
  default = {
    "1_name" = "vnet-spoke-1"
    "1_net" = "172.31.32.0/23"
    "2_name" = "vnet-spoke-2"
    "2_net" = "172.31.34.0/23"
  }
}

variable "subnets-spokes" {
  type = map(any)
  default = {
    "n-spoke-vm-1_net"  = "172.31.32.0/24"
    "n-spoke-vm-2_net"  = "172.31.34.0/24"
    "n-spoke-rs-1_net"  = "172.31.33.0/27"
    "n-spoke-rs-2_net"  = "172.31.35.0/27"
    "n-spoke-vm-1_name" = "subnet-spoke-1"
    "n-spoke-vm-2_name" = "subnet-spoke-2"
    "n-spoke-rs-1_name" = "RouteServerSubnet"
    "n-spoke-rs-2_name" = "RouteServerSubnet"
  }
}

variable "hub-advpn-public-ip" {
  type    = string
  default = "10.10.10.254"
}

variable "hub-advpn-mpls-ip" {
  type    = string
  default = "10.10.20.254"
}

variable "hub-vxlan-ip-1" {
    type    = string
    default = "10.10.30.1"
}

variable "hub-vxlan-ip-2" {
    type    = string
    default = "10.10.30.17"
}

variable "hub2-vxlan-ip-1" {
    type    = string
    default = "10.10.30.2"
}

variable "hub2-vxlan-ip-2" {
    type    = string
    default = "10.10.30.18"
}

variable "hub-peer-ip1" {   
  type    = string
  default = "172.31.4.10"
}

variable "hub-peer-ip2" {   
  type    = string
  default = "172.31.4.11"
}

variable "hub-peer-bgp-asn" {   
  type    = string
  default = "65001"
}

variable "cluster-public-ip_name" {
  type    = string
  default = "cluster-public-ip"
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

// FOS version
variable "fgtversion" {
  type    = string
  default = "7.2.0"
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

variable "fgt-bgp-asn" {
  type    = string
  default = "65001"
}

variable "sites-bgp-asn" {
  type    = string
  default = "65011"
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

