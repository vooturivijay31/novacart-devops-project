variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "novacart"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "centralindia"
}

variable "acr_name" {
  description = "Globally unique Azure Container Registry name"
  type        = string

  validation {
    condition = (
      length(var.acr_name) >= 5 &&
      length(var.acr_name) <= 50 &&
      can(regex("^[a-z0-9]+$", var.acr_name))
    )
    error_message = "ACR names must be 5-50 characters and contain only lowercase letters and numbers."
  }
}

variable "postgres_server_name" {
  description = "Globally unique PostgreSQL Flexible Server name"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]{1,61}[a-z0-9]$", var.postgres_server_name))
    error_message = "Use a 3-63 character PostgreSQL server name with lowercase letters, numbers, or internal hyphens."
  }
}

variable "postgres_admin_username" {
  description = "PostgreSQL administrator username"
  type        = string
  default     = "novacartadmin"
}

variable "postgres_admin_password" {
  description = "PostgreSQL administrator password"
  type        = string
  sensitive   = true
}

variable "postgres_version" {
  description = "PostgreSQL major version"
  type        = string
  default     = "16"
}

variable "postgres_sku_name" {
  description = "Development PostgreSQL compute SKU"
  type        = string
  default     = "B_Standard_B1ms"
}

variable "postgres_storage_mb" {
  description = "PostgreSQL storage size in MB"
  type        = number
  default     = 32768
}

variable "tags" {
  description = "Additional Azure resource tags"
  type        = map(string)
  default     = {}
}

variable "frontend_image_tag" {
  description = "Existing frontend image tag in Azure Container Registry"
  type        = string
  nullable    = false

  validation {
    condition     = length(trimspace(var.frontend_image_tag)) > 0
    error_message = "frontend_image_tag must not be empty."
  }
}

variable "backend_image_tag" {
  description = "Existing backend image tag in Azure Container Registry"
  type        = string
  nullable    = false

  validation {
    condition     = length(trimspace(var.backend_image_tag)) > 0
    error_message = "backend_image_tag must not be empty."
  }
}