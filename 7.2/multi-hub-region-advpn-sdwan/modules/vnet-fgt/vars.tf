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

variable "vnet-fgt-cidr" {
  default = "172.31.0.0/20"
}

variable "vnet-spoke-1-cidr" {
  default = "172.31.32.0/23"
}

variable "vnet-spoke-2-cidr" {
  default = "172.31.34.0/23"
}

// enable accelerate network, either true or false, default is false
// Make the the instance choosed supports accelerated networking.
// Check: https://docs.microsoft.com/en-us/azure/virtual-network/accelerated-networking-overview#supported-vm-instances
variable "accelerate" {
  default = "false"
}

variable "nsg_ids"{
  default = ["nsg-mgmt-ha_id", "nsg-public_id", "nsg-private_id"]
}







