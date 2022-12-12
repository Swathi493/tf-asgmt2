resource "azurerm_data_factory" "adf" {
  name                = var.data_factory_name
  resource_group_name = var.rsgrp
  location            = var.location

  tags = var.tags
}
resource "azurerm_databricks_workspace" "adb" {
   name                = var.data_bricks_name
  resource_group_name = var.rsgrp
  location            = var.location
  sku                 = "standard"
  tags= var.tags
}
resource "azurerm_virtual_network" "vnet" {
  name                = var.vn_name
  address_space       = ["${var.vnet_cidr_prefix}"]
  location            = var.location
  resource_group_name = var.rsgrp
  tags = var.tags
}

resource "azurerm_subnet" "subnet" {
  name                 = var.sn_name
  resource_group_name  = var.rsgrp
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["${var.subnet1_cidr_prefix}"]
  service_endpoints    = ["Microsoft.Sql"]
  
}
resource "random_password" "password" {
  length           = 8
  lower            = true
  min_lower        = 1
  min_numeric      = 1
  min_special      = 1
  min_upper        = 1
  numeric          = true
  override_special = "_"
  special          = true
  upper            = true
}

resource "azurerm_mssql_server" "sqlserver" {
  name                         = var.sql_server_name
  resource_group_name          = var.rsgrp
  location                     = var.location
  administrator_login          = var.admin
  administrator_login_password = random_password.password.result
  tags = var.tags
  version                      = "12.0"
  
  minimum_tls_version          = "1.2"

}
resource "azurerm_storage_account" "storage_account" {
  name                     = var.storage_account_name
  resource_group_name      = var.rsgrp
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
   
  account_kind             = "StorageV2"
  
  tags = var.tags 
}

resource "azurerm_storage_container" "container" {
  count = length(var.user_names)
  name  = var.user_names[count.index]
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}
resource "azurerm_data_factory_pipeline" "adfpipeline" {
  name            = var.adf_pipeline_name
  data_factory_id = azurerm_data_factory.adf.id
}
resource "azurerm_data_factory_linked_service_data_lake_storage_gen2" "linked_service" {
  count                 = 1
  data_factory_id       = azurerm_data_factory.adf.id
  name                  = var.linked_service_name
  service_principal_id  = var.client_id
  service_principal_key = var.client_secret
  tenant                = var.tenant_id
  url                   = azurerm_storage_account.storage_account.primary_dfs_endpoint
}
resource "azurerm_service_plan" "azsp" {
  name                = var.service_principle_name
  resource_group_name = var.rsgrp
  location            = var.location
  os_type             = "Windows"
  sku_name            = "Y1"
}

resource "azurerm_windows_function_app" "azfuncapp" {
  name                = var.func_app_name
  resource_group_name = var.rsgrp
  location            = var.location

  storage_account_name       = azurerm_storage_account.storage_account.name
  storage_account_access_key = azurerm_storage_account.storage_account.primary_access_key
  service_plan_id            = azurerm_service_plan.azsp.id

  site_config {}
}
resource "azurerm_kusto_cluster" "azkc" {
  name                = var.kustocluster
  location            = var.location
  resource_group_name = var.rsgrp

  sku {
    name     = "Standard_D13_v2"
    capacity = 2
  }

  tags = var.tags 
}
resource "azurerm_analysis_services_server" "server" {
  name                    = var.analysis_server
  location                = var.location
  resource_group_name     = var.rsgrp
  sku                     = "S0"
  admin_users             = [var.admin]
  enable_power_bi_service = true
 
  
  
  
  tags = var.tags
}
resource "azurerm_mssql_elasticpool" "az-elastic-pool" {
  name                = var.sqlelasticpoolname
  resource_group_name = var.rsgrp
  location            = var.location
  server_name         = azurerm_mssql_server.sqlserver.name
  license_type        = "LicenseIncluded"
  max_size_gb         = "50"
  sku {
    name     = "StandardPool" 
    tier     = "Standard"
    capacity = "50"
  }
  per_database_settings {
    min_capacity = "0"
    max_capacity = "10"
  }
  tags = var.tags

}

#Azure SQL Database
resource "azurerm_mssql_database" "sql-db" {
  name            = var.sqldbname
  elastic_pool_id = azurerm_mssql_elasticpool.az-elastic-pool.id
  server_id       = azurerm_mssql_server.sqlserver.id
  max_size_gb     =  "5" 
  sku_name        = "ElasticPool"
  tags            = var.tags
}