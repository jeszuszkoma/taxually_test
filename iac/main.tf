terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "3.0.0"
    }
  }
  backend "azurerm" {
    resource_group_name = "Terraform-POC"
    storage_account_name = "resourcetest12"
    container_name = "state"
    key = "terraform.state"
  }
}

provider "azurerm" {
  skip_provider_registration = "true"
  features {
  }
}

#########################################
#              RESOURCES                #
#########################################

#Res Group
resource "azurerm_resource_group" "TestXam" {
  name = "${var.environmentName}-${var.project}"
  location = var.location
}

#Service Plan
resource "azurerm_service_plan" "TestXamPlan" {
  name = "${var.environmentName}-${var.project}"
  resource_group_name = azurerm_resource_group.TestXam.name
  location = azurerm_resource_group.TestXam.location
  sku_name = "B1"
  os_type = "Linux"
  tags = local.common_tags
}

#Storage acc for function app
resource "azurerm_storage_account" "TestXamFuncStorage" {
  name = "testxamstrg"
  location            = azurerm_resource_group.TestXam.location
  resource_group_name = azurerm_resource_group.TestXam.name
  account_tier = "Standard"
  account_replication_type = "LRS"
  tags = local.common_tags
}

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

#SQL Server
resource "azurerm_mssql_server" "TestXam_SQL_Server" {
  name = "${var.environmentName}-${var.project}server"
  resource_group_name = azurerm_resource_group.TestXam.name
  location = azurerm_resource_group.TestXam.location
  version = "12.0"
  administrator_login = var.sql_admin
  administrator_login_password = var.sql_admin_password
  tags = local.common_tags
}

#SQL Firewall Rule
resource "azurerm_mssql_firewall_rule" "TestXam_SQL_Firewall" {
  name = "FireWallRule"
  server_id = azurerm_mssql_server.TestXam_SQL_Server.id
  start_ip_address = "0.0.0.0"
  end_ip_address = "0.0.0.0"
}

#SQL Database
resource "azurerm_mssql_database" "TestXam_Database" {
  name = "${var.environmentName}-${var.project}db"
  server_id = azurerm_mssql_server.TestXam_SQL_Server.id
  sku_name = "S0"
  tags = local.common_tags
}


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

  auth_settings {
    enabled               = true
    active_directory {
      client_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    }
    default_provider = "AzureActiveDirectory"
    issuer = "https://login.microsoftonline.com/<tenant_id>"
  }

  app_settings = {
    "ServiceBus_ConnectionString" = azurerm_servicebus_namespace.TestXam_ServiceBus_Namespace.default_primary_connection_string
    "ServiceBus_QueueName" = var.testxam_servicebus_queue
  }
}

#Function app
resource "azurerm_linux_function_app" "TestXamFunc" {
  name = "${var.environmentName}-${var.project}"
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

#APIM
resource "azurerm_api_management" "TestXamApim" {
  name = "${var.environmentName}-${var.project}"
  location            = azurerm_resource_group.TestXam.location
  resource_group_name = azurerm_resource_group.TestXam.name
  sku_name = "Developer_1"
  publisher_name = "TestXam"
  publisher_email = "testxam@gmail.com"
}