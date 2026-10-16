1. how the development deployment is assembled
NovaCart is deployed to Azure using Terraform-managed infrastructure and containerized frontend and backend applications. The frontend is publicly accessible, while the backend uses internal ingress within Azure Container Apps. The backend connects to Azure Database for PostgreSQL Flexible Server.

2. which Azure services are involved
Azure Container Apps, Azure Container Registry (ACR), Azure Database for PostgreSQL Flexible Server, Azure Log Analytics Workspace, Azure Managed Identity

3. which endpoint the frontend uses to reach the backend - backend's internal Container Apps hostname

4. which endpoint the backend uses to reach the database - DATABASE_URL environment variable
postgresql://<username>:<password>@vijay-postgresql-db.postgres.database.azure.com:5432/novacart?sslmode=require

5. what the expected development endpoint(s) are - Frontend, Frontend API - Products, Frontend API — orders, Backend internal readiness

6. what you verified after deployment - 

- Confirmed that the frontend Container App revision became healthy and its Nginx process started successfully.
- Verified that the frontend root endpoint returned HTTP 200.
- Checked the backend's internal readiness endpoint. HTTP requests were redirected to HTTPS, and the HTTPS request returned HTTP 200 with a JSON response.
- Verified that the frontend API proxy configuration used the backend's internal hostname and HTTPS.
- Confirmed that the frontend API endpoints for products and orders worked as expected after the correction.
- Confirmed that the application could start with PostgreSQL configured as its database backend.