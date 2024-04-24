#APIM
resource "azurerm_api_management" "TestXamApim" {
  name = "${var.environmentName}-${var.project}"
  location            = azurerm_resource_group.TestXam.location
  resource_group_name = azurerm_resource_group.TestXam.name
  sku_name = "Developer_1"
  publisher_name = "TestXam"
  publisher_email = "testxam@gmail.com"
}