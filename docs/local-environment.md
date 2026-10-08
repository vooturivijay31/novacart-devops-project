1. How the complete environment is started and stopped
Start - docker compose up -d
Stop - docker compose down

2. How individual services can be restarted
docker compose restart <svc_name>
svc_name - frontend/backend/postgres

3. How the frontend container and webserver run
The image contains Nginx and the NovaCart frontend files.Nginx runs inside the frontend container and serves the static HTML, CSS, and JavaScript files.

4. How services discover and communicate with each other
Docker Compose automatically creates a network for the services.Services communicate using their Compose service names rather than IPs

5. How runtime configuration is supplied 
Using environment variables in compose.yaml

6. How database persistence is handled - Docker volumes

7. How service health and readiness are determined
Health checks:
postgres - pg_ready
backend - /ready

The backend waits for PostgreSQL to become healthy before starting.The frontend waits for the backend to become healthy before starting.

8. What happens when an individual service restarts
when an individual service restarts , the other services continue to run even they are dependent , but the users experience failing api requests until the restarted service becomes healthy again.

9. Which services and ports are accessible from the host
Host port : 80
frontend container port : 80

10. Assumptions, trade-offs, and limitations
Assumptions - The frontend and backend images from the runtime-packaging task already exist locally. Host port 80 is available
trade-offs - 
limitations - 