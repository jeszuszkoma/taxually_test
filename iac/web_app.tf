#App Service
resource "azurerm_linux_web_app" "TestXamApp" {
  name                = "${var.environmentName}-${var.project}"
  location            = azurerm_resource_group.TestXam.location
  resource_group_name = azurerm_resource_group.TestXam.name
  service_plan_id = azurerm_service_plan.TestXamPlan.id
  tags = local.common_tags

  site_config {
    always_on = true
  }

  # auth_settings {
  #   enabled               = true
  #   active_directory {
  #     client_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  #   }
  #   default_provider = "AzureActiveDirectory"
  #   issuer = "https://login.microsoftonline.com/<tenant_id>"
  # }

  app_settings = {
    "ServiceBus_ConnectionString" = azurerm_servicebus_namespace.TestXam_ServiceBus_Namespace.default_primary_connection_string
    "ServiceBus_QueueName" = var.testxam_servicebus_queue
  }
}