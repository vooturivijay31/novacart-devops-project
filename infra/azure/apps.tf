resource "azurerm_container_app" "backend" {
  name                         = "${local.name_prefix}-backend"
  resource_group_name          = azurerm_resource_group.main.name
  container_app_environment_id = azurerm_container_app_environment.main.id
  revision_mode                = "Single"

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.container_apps.id]
  }

  registry {
    server   = azurerm_container_registry.main.login_server
    identity = azurerm_user_assigned_identity.container_apps.id
  }

  secret {
    name  = "database-url"
    value = "postgresql://${urlencode(var.postgres_admin_username)}:${urlencode(var.postgres_admin_password)}@${azurerm_postgresql_flexible_server.main.fqdn}:5432/${azurerm_postgresql_flexible_server_database.main.name}?sslmode=require"
  }

  template {
    min_replicas = 1
    max_replicas = 2

    container {
      name   = "novacart-backend"
      image  = "${azurerm_container_registry.main.login_server}/novacart-backend:${var.backend_image_tag}"
      cpu    = 0.5
      memory = "1Gi"

      env {
        name  = "APP_ENV"
        value = "container"
      }

      env {
        name  = "API_VERSION"
        value = "v1"
      }

      env {
        name  = "LOG_LEVEL"
        value = "INFO"
      }

      env {
        name        = "DATABASE_URL"
        secret_name = "database-url"
      }
    }
  }

  ingress {
    external_enabled = false
    target_port      = 8080
    transport        = "auto"

    traffic_weight {
    percentage      = 100
    latest_revision = true
  }
  }

  depends_on = [
    azurerm_role_assignment.acr_pull,
    azurerm_postgresql_flexible_server_database.main
  ]

  tags = local.common_tags
}

resource "azurerm_container_app" "frontend" {
  name                         = "${local.name_prefix}-frontend"
  resource_group_name          = azurerm_resource_group.main.name
  container_app_environment_id = azurerm_container_app_environment.main.id
  revision_mode                = "Single"

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.container_apps.id]
  }

  registry {
    server   = azurerm_container_registry.main.login_server
    identity = azurerm_user_assigned_identity.container_apps.id
  }

  template {
    min_replicas = 1
    max_replicas = 2

    container {
      name   = "novacart-frontend"
      image  = "${azurerm_container_registry.main.login_server}/novacart-frontend:${var.frontend_image_tag}"
      cpu    = 0.25
      memory = "0.5Gi"

      env {
        name  = "BACKEND_URL"
        value = "https://${azurerm_container_app.backend.ingress[0].fqdn}"
      }

      env {
        name  = "NGINX_ENVSUBST_FILTER"
        value = "^BACKEND_URL$"
      }
    }
  }

  ingress {
    external_enabled = true
    target_port      = 80
    transport        = "auto"

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  depends_on = [
    azurerm_role_assignment.acr_pull,
    azurerm_container_app.backend
  ]

  tags = local.common_tags
}