#Res Group
resource "azurerm_resource_group" "TestXam" {
  name = "${var.environmentName}-${var.project}"
  location = var.location
}
