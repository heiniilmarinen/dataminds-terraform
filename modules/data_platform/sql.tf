data "azurerm_client_config" "this" {
}

resource "azurerm_mssql_server" "sql" {
  name                         = "sql-${var.name}"
  resource_group_name          = var.rg_name
  location                     = var.location
  version                      = "12.0"

  azuread_administrator {
    login_username              = var.sql_admin
    object_id                   = data.azurerm_client_config.this.object_id
    azuread_authentication_only = true
  }
}

resource "azurerm_mssql_database" "sql_db" {
  name      = "db-${var.name}"
  server_id = azurerm_mssql_server.sql.id
  sku_name  = "S0"
}