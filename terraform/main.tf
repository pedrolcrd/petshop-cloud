provider "azurerm" {
  features {}
  subscription_id = "ec1900ce-7417-4858-b7ad-61507fdf84a3"
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "azurerm_resource_group" "rg" {
  name     = "petshop-rg-${random_id.suffix.hex}"
  location = var.location
}

# Substitua azurerm_app_service_plan por azurerm_service_plan
resource "azurerm_service_plan" "plan" {
  name                = "petshop-plan-${random_id.suffix.hex}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "B1"  # Basic tier
}

# Atualize para azurerm_linux_web_app (substituto moderno do azurerm_app_service)
resource "azurerm_linux_web_app" "app" {
  name                = "petshop-app-${random_id.suffix.hex}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.plan.id

  site_config {
    application_stack {
      python_version = "3.9"
    }
    always_on = true
  }

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE"    = "0"
    "FLASK_APP"                   = "main.py"
    "FLASK_ENV"                   = "production"
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "true"
  }
}