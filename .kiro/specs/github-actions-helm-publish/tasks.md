# Implementation Plan

- [x] 1. Create GitHub Actions workflow file structure
  - Create `.github/workflows/helm-publish.yml` file
  - Configure workflow_dispatch trigger with publish input parameter
  - Set up required permissions (contents: write, pages: write, id-token: write)
  - Define environment variables for chart directory path
  - _Requirements: 1.1, 5.1, 5.2, 5.4_

- [x] 2. Implement Helm chart linting job
  - Add lint job that runs on ubuntu-latest runner
  - Check out repository code using actions/checkout@v5
  - Install Helm using azure/setup-helm@v4 with version 3.x
  - Execute helm lint command against kubernetes/glpi directory
  - Configure job to fail workflow on linting errors
  - _Requirements: 1.1, 1.2, 1.3, 1.4_

- [x] 3. Implement Helm chart packaging job
  - Add package job with dependency on successful lint job
  - Check out repository code
  - Install Helm
  - Extract chart version from Chart.yaml using yq or grep
  - Execute helm package command to create .tgz archive
  - Store packaged chart in .cr-release-packages directory
  - Upload packaged chart as workflow artifact for debugging
  - _Requirements: 2.1, 2.2, 2.3, 2.4_

- [x] 4. Implement chart repository publishing job
  - Add publish job with dependency on successful package job
  - Add conditional execution based on publish input parameter
  - Check out repository code with full history (fetch-depth: 0)
  - Configure Git user for commits (name and email)
  - Install Helm
  - Use helm/chart-releaser-action@v1 to publish chart
  - Configure action to update index.yaml and push to gh-pages branch
  - Set CR_TOKEN environment variable to GITHUB_TOKEN
  - _Requirements: 3.1, 3.2, 3.3, 3.4, 4.3, 5.1, 5.2, 5.3_

- [x] 5. Add workflow documentation
  - Create or update README.md with Helm repository usage instructions
  - Document how to manually trigger the workflow from GitHub UI
  - Include helm repo add command with repository URL
  - Document the publish input parameter and its purpose
  - Add troubleshooting section for common issues
  - _Requirements: 3.4_

- [x] 6. Configure GitHub Pages for chart repository
  - Document GitHub Pages setup steps in README
  - Note that gh-pages branch will be created automatically on first publish
  - Include verification steps to confirm Pages is enabled
  - _Requirements: 3.4_

- [x] 7. Create workflow validation tests
  - Document manual testing procedure for the workflow
  - Create test checklist for lint-only execution (publish: false)
  - Create test checklist for full publish execution (publish: true)
  - Document expected outputs and verification steps
  - _Requirements: 1.1, 1.2, 2.1, 3.1_
