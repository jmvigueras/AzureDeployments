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

variable "hamgmt-cidr"{
  default = "172.31.0.0/16"
}

variable "admins-cidr"{
  default = "0.0.0.0/0"
}

variable "admins-port"{
  default = "8443"
}

variable "spoke-vnet-cidr" {
  default = "172.31.0.0/16"
}

variable "spoke-site-cidr" {
  default = "192.168.0.0/16"
}