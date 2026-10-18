output "resource_group_name" {
  description = "NovaCart resource group"
  value       = azurerm_resource_group.main.name
}

output "azure_region" {
  description = "Azure deployment region"
  value       = azurerm_resource_group.main.location
}

output "container_apps_environment_name" {
  description = "Shared Container Apps Environment"
  value       = azurerm_container_app_environment.main.name
}

output "container_apps_environment_id" {
  description = "Container Apps Environment resource ID"
  value       = azurerm_container_app_environment.main.id
}

output "acr_login_server" {
  description = "Registry hostname for future application images"
  value       = azurerm_container_registry.main.login_server
}

output "container_apps_identity_id" {
  description = "User-assigned managed identity resource ID"
  value       = azurerm_user_assigned_identity.container_apps.id
}

output "container_apps_identity_client_id" {
  description = "Client ID for future Container Apps image-pull configuration"
  value       = azurerm_user_assigned_identity.container_apps.client_id
}

output "postgres_server_name" {
  description = "PostgreSQL Flexible Server name"
  value       = azurerm_postgresql_flexible_server.main.name
}

output "postgres_server_fqdn" {
  description = "PostgreSQL server hostname"
  value       = azurerm_postgresql_flexible_server.main.fqdn
}

output "postgres_database_name" {
  description = "NovaCart database name"
  value       = azurerm_postgresql_flexible_server_database.main.name
}

output "postgres_port" {
  description = "PostgreSQL TCP port"
  value       = 5432
}

output "log_analytics_workspace_id" {
  description = "Log Analytics Workspace resource ID"
  value       = azurerm_log_analytics_workspace.main.id
}

output "frontend_url" {
  description = "Public URL of the NovaCart frontend"
  value       = "https://${azurerm_container_app.frontend.ingress[0].fqdn}"
}