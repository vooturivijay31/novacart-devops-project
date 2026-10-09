1. Workflow Triggers - The workflow runs when code is pushed to main or when a pull request is opened to the main branch.

2. Validation Stages - checkout, Gitleaks, python setup, dependency installation, backend tests, frontend Docker image build, and backend Docker image build.

3. What Is Tested or Built - Backend tests are run and docker images for both frontend and backend are built

4. What Happens When a Check Fails - The workflow stops at the failed step, skips subsequent steps, and reports a failed status

5. Pull Request Integration - For every PR to main this workflow triggers , only after successful CI validation , it is merged into Main

6. Secrets and Credentials - sensitive credentials should be stored in GitHub Secrets when needed

7. Limitations and Production Improvements - The workflow currently runs backend tests and builds container images but does not push images to a registry or deploy the application. Before production use, add dependency and image vulnerability scanning, image publishing to a registry, deployment validation, and appropriate environment protections like using github environments.
