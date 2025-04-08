output "app_service_url" {
  value       = "https://${azurerm_linux_web_app.app.default_hostname}"
  description = "URL do App Service"
}

output "suffix" {
  value = random_id.suffix.hex
}

output "webapp_name" {
  value = azurerm_linux_web_app.app.name
}

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}
