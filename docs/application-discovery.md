NovaCart — Application Discovery

1. Application Components

NovaCart consists of two application components and one database dependency:

Frontend

path: novacart/frontend/

The frontend is a static web application consisting of:

- index.html — UI structure
- styles.css — styling
- app.js — frontend logic and API communication

The frontend runs in the user's browser.

Backend

path: novacart/backend/

The backend is a Python FastAPI application.

Main entrypoint: novacart/backend/app/main.py

The backend provides APIs for:

- retrieving products
- creating orders
- retrieving orders
- application health
- application readiness
- runtime information

Database

The backend uses a relational database.

- PostgreSQL is used when DATABASE_URL points to PostgreSQL.
- SQLite is used as the local fallback when DATABASE_URL is not configured.


2. Languages and Frameworks

 Frontend - HTML, CSS, JavaScript 
 Backend - Python 
 Web framework - FastAPI 
 Application server - Uvicorn 
 PostgreSQL driver - psycopg 
 Production database - PostgreSQL 
 Local database fallback - SQLite 

Backend dependencies are defined in: novacart/backend/requirements.txt

Current dependencies:
fastapi==0.128.2
uvicorn==0.48.0
psycopg[binary]>=3.2,<4

3. Startup and Build Commands

Backend
Install the python dependencies

cd novacart/backend
pip install -r requirements.txt

Start the backend:

python -m uvicorn app.main:app --host 0.0.0.0 --port 8080

The command starts the FastAPI application defined as app in:
backend/app/main.py

There is no separate frontend build step in the repository.
Frontend
The frontend consists of static HTML, CSS, and JavaScript files.
It can be served by a static web server.

4. Listening Ports
The backend listens on: 8080

The main API endpoints are:
GET  /health
GET  /ready
GET  /api/products
GET  /api/orders
POST /api/orders
GET  /api/runtime

5. Application Dependencies

The backend requires: Python, FastAPI, Uvicorn, psycopg
The frontend requires a modern web browser

6. Configuration and Environment Variables

The application reads configuration from environment variables.
The example configuration is provided in: novacart/.env.example

APP_ENV - Defines the application environment
API_VERSION - Defines the configured API version
DATABASE_URL - Defines the database connection

if DATABASE_URL is not configured , the application falls back to: sqlite:///./novacart.db

7. Secrets and Sensitive Configuration

DATABASE_URL is sensitive because it may contain database credentials.
Example: postgresql://username:password@host:5432/database

Production database credentials should not be committed to the repository. The real production value should be supplied through the deployment environment or a secret-management mechanisms like Hashicorp Vault.

8. Persistence Requirements
The application stores persistent data in the database.

The database contains:

Products - productId, product name, price
Orders - order reference, creation time, promo code, subtotal, discount, total
Order Items - product ID, product name, unit price, quantity, line total

The database therefore contains application state that must persist across application restarts.
SQLite creates a local novacart.db file when the SQLite fallback is used.
For the PostgreSQL configuration, the PostgreSQL database must provide the required persistent storage.

9. Database Dependencies
The backend connects to the configured database through DATABASE_URL.
The application supports: PostgreSQL, SQLite

The application initializes the database schema and seeds the initial products during startup.
Database connectivity is required for normal database operations and for the readiness check.

10. Health and Readiness Behavior

GET /health - The health endpoint verifies that the application is running and responding.

It does not perform a database connectivity check.
A successful response indicates that the application process is responding.

GET /ready - The readiness endpoint checks database connectivity by executing a simple database query.

If the database is available, the endpoint returns a successful response.

If the database cannot be reached, the endpoint returns:
503 Service Unavailable

Therefore:
- /health verifies application health.
- /ready verifies that the application is ready to serve database-dependent requests.

11. Service-to-Service Communication

There are two main communication paths.

Frontend → Backend
The browser communicates with the FastAPI backend through HTTP REST APIs.

Examples:
GET /api/products
GET /api/orders
POST /api/orders

The frontend uses JavaScript fetch() to make these requests.
When the frontend is served normally, the API base path is: /api

When the frontend is opened directly using file://, it uses: http://localhost:8080/api

Backend → Database
The FastAPI backend communicates with the database using the configured database driver.
For PostgreSQL:
FastAPI --> psycopg --> PostgreSQL

There are no other application service-to-service communication dependencies identified in the repository.

12. Logging Behavior
The backend uses Python's standard logging framework.
The logging level is controlled through: LOG_LEVEL

The default level is:
INFO

Logs are written to standard output (stdout).
The application logs:
- application startup
- startup failures
- HTTP requests
- HTTP response status codes
- request duration
- application exceptions
- database/readiness failures

Because logs are written to stdout, the runtime environment can collect them through its normal logging mechanism.

13. External Dependencies
The main external runtime dependency is: PostgreSQL

14. Runtime Assumptions
The following runtime assumptions were identified:
- Python is available for the backend.
- Backend dependencies can be installed from requirements.txt.
- Uvicorn is used to run the FastAPI application.
- The backend listens on port 8080.
- Required environment variables are available to the backend.
- The backend can reach the configured database.
- PostgreSQL is available when PostgreSQL is configured through DATABASE_URL.
- The frontend can reach the backend API.
- The frontend is served as static files or opened locally for development.
- The application has write access to the local filesystem when SQLite is used.


15. Risks and Missing Information
The following information is not defined in the current application/repository and should be clarified before production deployment:
- Production Python version has not been explicitly defined.
- Production PostgreSQL version has not been specified.
- Expected application traffic and concurrent users are not specified.
- CPU and memory requirements are not specified.
- Production availability requirements are not specified.
- Database backup and recovery requirements are not specified.
- Production authentication and authorization requirements are not specified.
- Production CORS requirements are not specified.
- Production logging and monitoring requirements are not specified.
- Production secret-management mechanism is not specified.
- Production frontend hosting method is not specified.
- Production database hosting method is not specified.
- Deployment and rollback requirements are not specified.

16. Questions for the Development Team
Before production deployment, I would ask the development team:
- Which Python version should be used in production?
- Which PostgreSQL version should be used?
- What are the expected traffic and concurrent-user requirements?
- What CPU and memory resources does the application require?
- What availability/SLA requirements does the application have?
- What is the required database backup and recovery strategy?
- Is authentication and authorization required before production?
- Which frontend origins should be allowed to access the API?
- Where should production secrets be stored?
- What logging and monitoring platform should be used?
- Where should the frontend be hosted?
- Where should PostgreSQL be hosted?
- What deployment and rollback process is expected?