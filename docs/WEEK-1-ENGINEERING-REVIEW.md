Source Control
1. How does your Git workflow operate?
main — production-ready code. Protected, feature/<short-description> — normal development work, hotfix/<short-description> — urgent production fixes.

2. How is main protected? - Main is protected by GitHub repository settings. Code must go through pull request before merging, at least one reviewer approval, and a successful required CI status check.

3. How are changes reviewed and validated? - Every pull request targeting main automatically triggers GitHub Actions. The current workflow scans for secrets using Gitleaks, installs backend dependencies, runs backend tests using pytest, and builds the frontend and backend Docker images using tags based on the short Git commit SHA.

4. How would an emergency fix be handled? - A developer creates a hotfix branch from main, implements the fix, and opens a pull request targeting main. The fix follows the normal review and CI process. After approval and successful validation, the fix is merged into main.

Runtime & Application
1. How is the application packaged? - NovaCart is packaged as frontend and backend docker images , PostgreSQL runs as a separate database container using the official PostgreSQL image.

2. How are frontend, backend, and PostgreSQL started? - The three services are defined in novacart/compose.yaml. They can be started together using docker compose up -d

3. How do services discover and communicate with each other? - Using service-name-based DNS resolution  provided by docker compose

4. How is runtime configuration supplied? - Runtime configuration is injected using environment variables

5. Where does persistent data live? - PostgreSQL stores its data in the named Docker volume postgres_data

6. How are health and readiness verified? - Backend exposes /health and /ready endpoints. The health endpoint checks application responsiveness, while the readiness endpoint queries the database to verify connectivity. Compose configuration uses health checks on backend and postgres services and service dependencies to help coordinate service startup.

CI
1. What happens when a pull request is created? - if the PR is targets main then  github actions workflow triggers executes defined steps and fails if any one of the steps fails
2. What does CI validate? - Secret scanning, Backend testing, Image tagging, Image building
3. What happens when validation fails? - If a step fails, subsequent steps are skipped by default and the job is marked as failed
4. Which checks are required before merge? - successful CI status check and One review
5. What important checks are still missing? - Code Coverage, Integration testing, Image scanning, Post deployment verification

Production Readiness

Risk 1 - Hardcoded database credentials and incomplete secret handling
Priority: High
Problem: compose file contains the database password in both the PostgreSQL configuration and the backend connection string. 
Impact: Configuration may expose credentials through source control or copied deployment files.
Improvement: Externalize runtime configuration,use Azure Key Vault or Hashicorp vault, inject secrets during runtime.

Risk 2 —  Automated test coverage
Priority: High
Problem: The current CI focuses on backend tests, frontend tests and integration tests are missing.
Impact: Bugs in user flows , frontend-to-backend communication could reach later environments.
Improvement: Add frontend tests and integration tests covering database operations and order workflows.

Risk 3 - Container and dependency security
Priority: High
Problem: Successful image builds do not establish that images and dependencies are free of known vulnerabilities.
Impact: Vulnerable dependencies or container packages could expose the application to attacks.
Improvement: Scan dependencies and images, pin dependencies appropriately, and verify non-root execution and image hardening.

Risk 4 - Readiness checks do not verify the complete application state
Priority: Medium
Evidence: The /ready endpoint in executes SELECT 1 against the database.
Problem: This verifies database connectivity but does not confirm that required tables and application data are available.
Impact: The service may report itself ready even when API operations that depend on database tables fail.
Improvement: Extend the /ready endpoint to verify database connectivity and the availability of essential application tables.

Risk 5 — Unauthenticated order API
Priority: High
Problem: Backend exposes GET /api/orders, which returns order history, and POST /api/orders, which creates orders. Neither endpoint implements authentication or authorization. CORS is configured to allow all origins.
Potential impact: If the API is exposed to the internet, unauthorized users could access order information or create unwanted orders. A permissive CORS policy also allows browser-based cross-origin requests, although CORS alone is not an authentication control.
Recommended improvement: Define the authentication and authorization requirements, implement them at the application layer, restrict allowed origins, and test access-control behavior before any public exposure.

I would choose - READY TO PROCEED TO CLOUD INFRASTRUCTURE DESIGN

The justification is that NovaCart has a defined architecture, separate container images, a Compose configuration, and basic CI validation. These provide a foundation for designing and testing an Azure environment.Testing in a non-production Azure environment can reveal cloud-specific issues that local Docker does not expose, such as incorrect environment variables, networking problems, database connectivity, managed identity permissions, and container startup failures.

However deploying to Azure does not automatically make the application secure or reliable. We need to address the above risks in parallel with Azure infrastructure design and resolve them before production launch.


