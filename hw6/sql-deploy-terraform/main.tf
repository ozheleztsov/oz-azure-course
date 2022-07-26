terraform {
  required_version = "~>v1.2.4"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }
}


provider "azurerm" {
  features {}
  tenant_id = ""
  client_id = ""
  client_secret = ""
  subscription_id = ""
}

resource "azurerm_resource_group" "rg" {
    name = "ozexample-rg"
    location = "West Europe" 
}

resource "azurerm_mssql_server" "mssqlsrv" {
    name = "oz-azurecourse-sqlserver"
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    version = "12.0"
    administrator_login = "ozazurecourseadm"
    administrator_login_password = "4-v3ry-53cr37-p455w0rd" 

    tags = {
        environment = "dev"
    }  
}

resource "azurerm_mssql_database" "sampledb" {
    name = "oz-sampledb"
    server_id = azurerm_mssql_server.mssqlsrv.id
    collation      = "SQL_Latin1_General_CP1_CI_AS"
    license_type   = "LicenseIncluded"
    max_size_gb    = 1
    read_scale     = false
    sku_name       = "S0"
    zone_redundant = false

    tags = {
        environment = "dev"
    }  
}

