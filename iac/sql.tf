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