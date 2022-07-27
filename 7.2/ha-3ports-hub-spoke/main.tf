// Resource Group

resource "azurerm_resource_group" "myterraformgroup" {
  name     = "jvigueras-demo-hub-spoke"
  location = var.location

  tags = {
    environment = "jvigueras demo hub spoke"
  }
}
