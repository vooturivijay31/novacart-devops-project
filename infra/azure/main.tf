locals {
  name_prefix = "${var.project_name}-${var.environment}"

  common_tags = merge(
    {
      project     = var.project_name
      environment = var.environment
      managed_by  = "terraform"
    },
    var.tags
  )
}

# 1. Resource Group
resource "azurerm_resource_group" "main" {
  name     = "rg-${local.name_prefix}"
  location = var.location
  tags     = local.common_tags
}

# 2. Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "main" {
  name                = "law-${local.name_prefix}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  sku               = "PerGB2018"
  retention_in_days = 30

  tags = local.common_tags
}

# 3. Shared Container Apps Environment
# This creates the environment, not the application containers.
resource "azurerm_container_app_environment" "main" {
  name                       = "${local.name_prefix}-aca-env"
  location                   = azurerm_resource_group.main.location
  resource_group_name        = azurerm_resource_group.main.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id

  tags = local.common_tags

    lifecycle {
    ignore_changes = [workload_profile]
  }
}

# 4. Azure Container Registry
resource "azurerm_container_registry" "main" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  sku           = "Basic"
  admin_enabled = false

  tags = local.common_tags
}

# 5. Managed Identity for future Container Apps image pulls
resource "azurerm_user_assigned_identity" "container_apps" {
  name                = "id-${local.name_prefix}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  tags = local.common_tags
}

# 6. Permit the identity to pull images from ACR
# Assumes the registry uses the traditional RBAC permission model.
resource "azurerm_role_assignment" "acr_pull" {
  scope                = azurerm_container_registry.main.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.container_apps.principal_id
  principal_type       = "ServicePrincipal"
}

# 7. PostgreSQL Flexible Server
resource "azurerm_postgresql_flexible_server" "main" {
  name                = var.postgres_server_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  zone                = "3"

  version                = var.postgres_version
  administrator_login    = var.postgres_admin_username
  administrator_password = var.postgres_admin_password

  sku_name   = var.postgres_sku_name
  storage_mb = var.postgres_storage_mb

  backup_retention_days        = 7
  geo_redundant_backup_enabled = false

  # Public development endpoint; firewall rules still restrict access.
  public_network_access_enabled = true

  tags = local.common_tags
}

# 8. NovaCart application database
resource "azurerm_postgresql_flexible_server_database" "main" {
  name      = "novacart"
  server_id = azurerm_postgresql_flexible_server.main.id

  charset   = "UTF8"
  collation = "en_US.utf8"
}

# 9. Explicit PostgreSQL firewall rules
# No IP addresses are allowed by this configuration unless
# they are supplied through postgres_firewall_rules.
resource "azurerm_postgresql_flexible_server_firewall_rule" "allowed" {
  for_each = var.postgres_firewall_rules

  name      = each.key
  server_id = azurerm_postgresql_flexible_server.main.id

  start_ip_address = each.value.start_ip_address
  end_ip_address   = each.value.end_ip_address
}

#10. Send PostgreSQL logs and metrics to Log Analytics
resource "azurerm_monitor_diagnostic_setting" "postgres" {
  name                       = "diag-${local.name_prefix}"
  target_resource_id         = azurerm_postgresql_flexible_server.main.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id

  enabled_log {
    category = "PostgreSQLLogs"
  }

  enabled_log {
    category = "PostgreSQLFlexSessions"
  }

  enabled_log {
    category = "PostgreSQLFlexQueryStoreRuntime"
  }

  enabled_log {
    category = "PostgreSQLFlexQueryStoreWaitStats"
  }

  enabled_log {
    category = "PostgreSQLFlexTableStats"
  }

  enabled_log {
    category = "PostgreSQLFlexDatabaseXacts"
  }

  enabled_log {
    category = "PostgreSQLFlexPGBouncer"
  }

  enabled_log {
    category = "PostgreSQLQueryStoreSqlText"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_azure_services" {
  name             = "AllowAzureServicesTemp"
  server_id        = azurerm_postgresql_flexible_server.main.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

