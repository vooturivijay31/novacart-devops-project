1. Required Azure Resources - Azure Resource Group, Azure Container Apps(ACA), Azure Container Registry (ACR), Log Analytics workspace, Azure managed identities, Azure role assignments

2. How the frontend and backend will run in Azure Container Apps - Frontend: Nginx serves static files on port 80 with external ingress, Backend: FastAPI/Uvicorn serves APIs on port 8080 with internal ingress.

3. How images are stored and accessed - Store frontend and backend images in ACR, Tag images using the Git commit SHA, CI builds and pushes the images, Container Apps pull them from ACR.

4. Traffic flow - Browser → Frontend (HTTPS) → Nginx → Backend → PostgreSQL

5. Endpoints used by each service - Browser → Frontend: https://<frontend-fqdn>/
   Browser API requests: https://<frontend-fqdn>/api/products
   Frontend → Backend: http://novacart-backend
   Backend → PostgreSQL: <postgres-server-fqdn>:5432

6. How backend reaches PostgreSQL - Configure DATABASE_URL with the PostgreSQL hostname, database name, credentials, and TLS settings, Allow backend connectivity to PostgreSQL on TCP port 5432.

7. Where PostgreSQL lives - Azure Database for PostgreSQL Server, a managed Azure database service.

8. Hostname, URL, port, and configuration assumptions - Frontend Nginx listens on port 80, Backend listens on port 8080,PostgreSQL uses port 5432, Both Container Apps share the same Container Apps environment, Replace the local Docker Compose hostname backend in nginx.conf with the Azure internal backend endpoint, Replace the local database hostname postgres with the actual Azure PostgreSQL hostname.

9. How Container Apps authenticate to ACR - User-assigned managed identity with required registry pull permission for image pulls.

10. Basic logging and monitoring - Send application logs, Container Apps system logs, and supported ingress logs to Log Analytics.

11. How Terraform manages the environment - Provision and manage Azure resources and Store Terraform state remotely in protected Azure Storage

12. Runtime assumptions - Frontend uses Nginx on port 80, Backend uses FastAPI/Uvicorn on port 8080, Backend uses PostgreSQL in Azure, Images are published to ACR before deployment, Required configuration and secrets are supplied securely at runtime.

13. Risks or missing information - Nginx upstream needs Azure-specific configuration, CI currently builds images but does not push them to ACR, Database connectivity, credentials, and TLS must be configured, Database migrations, secrets management, scaling, monitoring, and rollback need further work, Production security requirements are not yet defined.

14. Questions before production deployment - What traffic, availability, and scaling requirements are expected?, Is private database networking required?, How will API authentication and authorization be implemented?, What are the backup, recovery, and disaster-recovery requirements?, How will database migrations and application rollbacks be handled?, What log retention, alerting, and deployment approval policies are required?