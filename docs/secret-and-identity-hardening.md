1. What secrets exist?
PostgreSQL admin password, Backend database connection string (DATABASE_URL)

2. Where are the secrets stored?
PostgreSQL admin password - GitHub Actions Secret, Backend DATABASE_URL - Container Apps secret database-url

3. How does the application receive secrets? 
The backend Container App has this mapping:
env {
  name        = "DATABASE_URL"
  secret_name = "database-url"
}

4. How does deployment authentication work? - Using Azure OIDC

5. Which identities are used by which components? 
- GitHub Actions deployment identity - Microsoft Entra application/service principal using workload identity federation, GitHub Actions for Terraform and application delivery.
- Container Apps managed identity - Terraform plan/configuration uses it for Container Apps identity and ACR registry authentication. A role assignment azurerm_role_assignment.acr_pull grants ACR pull access

6. How can secrets be rotated without source-code changes?
PostgreSQL administrator password - rotate the password and update the github actions secret
