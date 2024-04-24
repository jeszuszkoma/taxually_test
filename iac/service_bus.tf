#Service Bus Namespace
resource "azurerm_servicebus_namespace" "TestXam_ServiceBus_Namespace" {
  name = var.testxam_servicebus_namespace
  resource_group_name = azurerm_resource_group.TestXam.name
  location = azurerm_resource_group.TestXam.location
  sku = "Standard"
  tags = local.common_tags
}

#Service Bus Queue
resource "azurerm_servicebus_queue" "TestXam_ServiceBus_Queue" {
  name = var.testxam_servicebus_queue
  namespace_id = azurerm_servicebus_namespace.TestXam_ServiceBus_Namespace.id

  enable_partitioning = true
}