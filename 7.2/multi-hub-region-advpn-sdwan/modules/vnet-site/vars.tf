variable "resourcegroup_name" {}

# Azure resourcers prefix description
variable "prefix" {
  type    = string
  default = "terraform"
}

variable "zone-id" {
  type    = string
  default = "zA"
}

# Azure resourcers prefix description
variable "tag_env" {
  type    = string
  default = "terraform-deploy"
}

variable "location" {
  type    = string
  default = "francecentral"
}

variable "vnet-fgt-site-cidr" {
  default = "192.168.0.0/21"
}

variable "vnet-spoke-site-cidr" {
  default = "192.168.10.0/23"
}

// enable accelerate network, either true or false, default is false
// Make the the instance choosed supports accelerated networking.
// Check: https://docs.microsoft.com/en-us/azure/virtual-network/accelerated-networking-overview#supported-vm-instances
variable "accelerate" {
  default = "false"
}

variable "site-id" {
  type    = string
  default = "1"
}

variable "nsg_ids"{
  type = list(string)
  default = ["nsg-mgmt-ha_id", "nsg-public_id", "nsg-private_id"]
}