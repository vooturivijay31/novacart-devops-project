1. Terraform Configuration Organization
main.tf - Defines the resource group, Log Analytics workspace, Azure Container Registry, managed identity, role assignment, PostgreSQL Flexible Server, database, firewall rules, and PostgreSQL diagnostic settings.
apps.tf - Defines the frontend and backend Azure Container Apps.
variables.tf - Declares required inputs, defaults, types, and validation rules.
outputs.tf - Exposes useful deployment information, including resource identifiers, endpoints, and database connection details that are safe to expose.
providers.tf - Configures the AzureRM provider and subscription.
versions.tf - Specifies the supported Terraform version and AzureRM provider version constraint.
backend.tf - Configures remote Terraform state in Azure Storage.

2. Environment-Specific Values
subscription_id, location, acr_name, frontend_image_tag, backend_image_tag, postgres_server_name
postgres_admin_username, postgres_admin_password, postgres_version, postgres_sku_name, postgres_storage_mb, postgres_firewall_rules

3. Values That Should Remain Stable
Resource naming conventions, remote state backend configuration and state key , database name, AzureRM provider version, Resource relationships, Logging and diagnostic configuration, Network access rules required for application-to-database connectivity

4. Prerequisites
Before running Terraform: Install a compatible Terraform version and Azure CLI, Authenticate to Azure and select the intended subscription, Confirm that the required Azure resource providers are registered, Confirm that the remote state resource group, storage account, and state container already exist, Ensure the executing identity has the required permissions to read and modify Azure resources and access the remote state, Supply all required variables, Ensure the frontend and backend image tags exist in the configured Azure Container Registry before deploying .

5. Conventions another engineer should follow when extending this code
Follow the existing file structure, Use variables for configurable values, Keep secrets out of source control, Maintain the existing Container Apps configuration, Validate every infrastructure change

6. Where to find the DEVOPS-009 deployment documentation
docs/azure-dev-deployment.md
This is the DEVOPS-009 deployment guide. It provides the environment-level explanation of your NovaCart deployment, including the frontend and backend containers, Azure services, connectivity, endpoints, and deployment verification.