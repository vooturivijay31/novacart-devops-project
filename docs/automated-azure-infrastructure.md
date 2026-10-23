1. Infrastructure Managed by the Pipeline - Azure Resource Group, Azure Container Registry (ACR), Azure Container Apps environment, Frontend and backend Container Apps, Azure Database for PostgreSQL Flexible Server and database, Virtual Network and delegated subnets, Private DNS zone and VNet link for PostgreSQL, User-assigned managed identity and required role assignments, Log Analytics workspace and diagnostic settings

2. Workflow Triggers - pull request or push to main , When changes affect infra/azure/** or the infrastructure workflow file

3. Review Before Applying Changes - The Plan job checks the Terraform configuration and generates a proposed infrastructure plan for review before the PR is merged. The Apply job runs after matching changes are pushed to main. It initializes Terraform, validates the configuration, generates a fresh plan, and applies that plan.

4. Terraform State Storage and Protection - stored remotely in Azure Blob Storage

5. Authentication Without Long-Lived Credentials - GitHub Actions authenticates to Azure through OpenID Connect (OIDC)

6. Workflow Results and Failures - Workflow runs are visible under the repository's Actions tab, The logs show the result of each step

7. Assumptions About the Azure Development Environment - The Azure subscription and tenant are configured correctly, Required Azure resource providers are registered, The Terraform backend storage account and container already exist, The GitHub OIDC federated credentials match the workflow's actual token subjects, The service principal has the required Azure RBAC permissions, Required Terraform variables are supplied through GitHub Variables, Secrets, or Terraform defaults.The GitHub environment azure-deployment exists and is configured appropriately.

8. Production Risks and Limitations 
- Shared identity permissions: The Plan job has the same Azure permissions as Apply. A compromised or malicious PR workflow could misuse those permissions.
- Automatic apply: Infrastructure changes reaching main can be applied automatically without a separate deployment approval unless the GitHub environment is configured to require one.