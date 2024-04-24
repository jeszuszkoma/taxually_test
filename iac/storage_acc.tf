#Storage acc for function app
resource "azurerm_storage_account" "TestXamFuncStorage" {
  name = "testxamstrg"
  location            = azurerm_resource_group.TestXam.location
  resource_group_name = azurerm_resource_group.TestXam.name
  account_tier = "Standard"
  account_replication_type = "LRS"
  tags = local.common_tags
}