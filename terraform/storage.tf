###################
# Storage account #
###################
resource "azurerm_storage_account" "sample" {
  name                      = "sasample${lower(var.user_name)}"
  resource_group_name       = data.azurerm_resource_group.main.name
  location                  = data.azurerm_resource_group.main.location
  account_kind              = "StorageV2"
  account_tier              = "Standard"
  account_replication_type  = "RAGRS"
  enable_https_traffic_only = true
}

#############
# Container #
#############
resource "azurerm_storage_container" "sample" {
  name                  = "sample"
  storage_account_name  = azurerm_storage_account.sample.name
  container_access_type = "private"
}

#########
# MySQL #
#########
resource "azurerm_mysql_server" "web" {
  name                = "mysql-${lower(var.user_name)}"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  sku_name                     = "GP_Gen5_2"
  storage_mb                   = 102400
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  auto_grow_enabled            = true

  administrator_login          = "webadmin"
  administrator_login_password = "This_is_my_super_password!"
  version                      = "5.7"
  ssl_enforcement_enabled      = false
}

# grant access to subnet
resource "azurerm_mysql_virtual_network_rule" "k8s" {
  name                = "${lower(var.user_name)}-default"
  resource_group_name = data.azurerm_resource_group.main.name
  server_name         = azurerm_mysql_server.web.name
  subnet_id           = azurerm_subnet.default.id
}