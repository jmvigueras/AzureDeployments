// Resource Group

resource "azurerm_resource_group" "myterraformgroup" {
  name     = "${var.prefix}-rg"
  location = var.location

  tags = {
    environment = var.tag_env
  }
}

# Randomize string to avoid duplication
resource "random_string" "random_text" {
  length           = 3
  special          = true
  override_special = ""
  min_lower        = 3
}

# IPSEC VPN 2to2 PSK key generation
resource "random_string" "advpn-ipsec-psk" {
  length           = 16
  special          = true
  override_special = "%&?()"
  min_lower        = 16
}
