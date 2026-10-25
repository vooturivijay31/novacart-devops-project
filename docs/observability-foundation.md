1. Where logs go - backend , platform , database logs go to Log Analytics workspace

2. What telemetry does the application emit? - backend uses Python logging and records request/status/duration information, exceptions, and order-creation summaries

3. Which metrics matter? - API request count and HTTP 5xx errors, API response time, Container CPU, memory, restarts, and replica count, PostgreSQL CPU, storage, connections, and failed connections, /ready failures

4. How is health checked? - Container Apps probes to use /health for liveness and /ready for readiness.

5. What helps during an incident? 
- Check whether the frontend and API respond.
- Compare /health and /ready results.
- In Azure, check the backend's active revision, replica count, restarts, CPU, and memory.
- In Log Analytics, search backend errors around the incident time and compare them with Container Apps system events.
- Check PostgreSQL CPU, storage, connections, and diagnostic logs.
- Compare the incident start time with the latest deployment or image revision.
- After mitigation, confirm /ready succeeds and API errors and latency return to normal.

6. Which alerts are meaningful? 
- PostgreSQL CPU high: Average CPU above 80% for 10 minutes
- API 5xx spike: More than 10 HTTP 5xx errors in 5 minutes, with enough request traffic
- Backend readiness failing: Repeated failures over several minutes

7. What creates alert noise? 
Avoid alerting on:
- A single failed health probe or a brief CPU spike.
- Every HTTP 4xx response; many are normal client errors.
- Every INFO log or successful deployment.
- The same issue separately from several alert rules without deduplication.