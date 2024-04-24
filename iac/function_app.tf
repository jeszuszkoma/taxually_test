#Function app
resource "azurerm_linux_function_app" "TestXamFunc" {
  name = "${var.environmentName}-${var.project}fn"
  location            = azurerm_resource_group.TestXam.location
  resource_group_name = azurerm_resource_group.TestXam.name
  tags = local.common_tags

  storage_account_name = azurerm_storage_account.TestXamFuncStorage.name
  storage_account_access_key = azurerm_storage_account.TestXamFuncStorage.primary_access_key
  service_plan_id = azurerm_service_plan.TestXamPlan.id

  site_config {
    always_on = true
    http2_enabled = true
  }

  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME" = "dotnet-isolated"
    "ServiceBus_ConnectionString" = azurerm_servicebus_namespace.TestXam_ServiceBus_Namespace.default_primary_connection_string
    "ServiceBus_QueueName" = var.testxam_servicebus_queue
  }
  
  connection_string {
    name = "ConnectionString"
    type = "SQLAzure"
    value = "Server=tcp:${azurerm_mssql_server.TestXam_SQL_Server.name}.database.windows.net,1433;Initial Catalog=${azurerm_mssql_database.TestXam_Database.name};Persist Security Info=False;User ID=${var.sql_admin};Password=${var.sql_admin_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  }
}