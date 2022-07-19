locals {
  resource_number = 1
}

# Resource group resource
resource "azurerm_resource_group" "rg" {
  name = "ozhw5resourcegroup-${local.resource_number}"
  location = var.location
}

# App service plan
resource "azurerm_service_plan" "appserviceplan" {
    name = "ozhw5webapp-asp-${local.resource_number}"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    os_type = "Linux"
    sku_name = "B1"
}

# Web app resource
resource "azurerm_linux_web_app" "webapp" {
    name = "ozhw5webapp-${local.resource_number}" 
    resource_group_name = azurerm_resource_group.rg.name
    location = var.location
    service_plan_id = azurerm_service_plan.appserviceplan.id
    site_config {
      application_stack {
        dotnet_version = "6.0"
      } 
    }
    
}

resource "azurerm_app_service_source_control" "appsource" {
  app_id = azurerm_linux_web_app.webapp.id
  repo_url = "https://github.com/Azure-Samples/dotnetcore-docs-hello-world"
  branch = "master"
  use_manual_integration = true
  use_mercurial = false
}