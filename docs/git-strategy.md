NovaCart Git Strategy

1. Branching Workflow
NovaCart uses a simple feature-branch workflow.

- main — production-ready code. Protected.
- feature/<short-description> — normal development work.
- hotfix/<short-description> — urgent production fixes.

Workflow:
feature/* → Pull Request → CI checks → Code review → main

For urgent fixes:
hotfix/* → Pull Request → CI checks → Expedited review → main

2. Developer contributions:
Creates a short-lived feature branch from main. Makes and tests their changes. Pushes the branch to GitHub. Opens a Pull Request against main. Waits for automated checks and code review. Addresses review comments if required. The approved PR is merged into main.


3. Protecting Production-Ready Code : main is the production-ready branch and is protected using GitHub repository settings.
Required protections: PR before merging to main, atleast 1 approval required, required CI check - backend tests

4. Automated checks - Backend tests are run in the CI pipeline for every PR to main

5. Emergency Fixes - developer creates a short-lived hotfix branch from main, even the hotfix follows the PR process to main

6. Why This Approach - This workflow fits NovaCart because the project has a small team of five developers and does not require separate release management. It provides Independent developer work, Code review before merging, Automated testing, separate emergency fix hotfix branch

7. Trade-offs 
There is no separate release branch for long-running release stabilization.



