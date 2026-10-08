1. What is your Docker packaging approach?
Frontend → Nginx Docker image
Backend  → Python/FastAPI Docker image

2. How are frontend and backend dependencies handled?
NovaCart's frontend is static HTML/CSS/JavaScript,the frontend image only needs Nginx to serve the files.
Backend dependencies are defined in requirements.txt file , during image build these are installed

3. How is the frontend served at runtime?
The frontend is served using Nginx inside the frontend container. It also acted as reverse proxy.

4. How is runtime configuration supplied - Docker environment variables

5. What database mode is used - SQLite fallback.

6. Which ports/interfaces are exposed?
Backend - Host 8080 → Container 8080
Frontend - Host 80 → Container 8080

7. How is each image built?
docker build -t novacart-frontend:1.0 ./frontend
docker build -t novacart-backend:1.0 ./backend

8. How is each application started separately?
docker run -d --name novacart-frontend --network novacart-network -p 80:80 novacart-frontend:1.0
docker run -d --name novacart-backend --network novacart-network -p 8080:8080 novacart-backend:1.0

Both the containers are spinned up in the same network.

9. What assumptions does the runtime environment have - must have docker installed and running and also port 80 and 8080 are not in use with other processes

10. What are the trade-offs and limitations?
SQLite
Advantage: Very simple; no database container required.
Limitation: Data is lost when the backend container is removed unless a volume is mounted.

Separate containers
Advantage: Frontend and backend can be independently built, tested, and deployed.
Limitation: Both containers need to be started and connected to the same Docker network manually.