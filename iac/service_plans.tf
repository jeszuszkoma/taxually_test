#Service Plan
resource "azurerm_service_plan" "TestXamPlan" {
  name = "${var.environmentName}-${var.project}"
  resource_group_name = azurerm_resource_group.TestXam.name
  location = azurerm_resource_group.TestXam.location
  sku_name = "B1"
  os_type = "Linux"
  tags = local.common_tags
}