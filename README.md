[![Stand With Ukraine](https://raw.githubusercontent.com/vshymanskyy/StandWithUkraine/main/banner2-direct.svg)](https://stand-with-ukraine.pp.ua)


# GLPI Containers


Manifest files for building and deploying **GLPI** using containers with Docker Compose or Kubernetes.

## Supported Containers

- [x] PHP-FPM: `php:8.4.13-fpm-alpine3.22`
- [x] Nginx: `nginxinc/nginx-unprivileged:1.29.1-alpine3.22-slim`
- [x] GLPI PHP: `eftechcombr/glpi:php-fpm-11.0.2`
- [x] GLPI Nginx: `eftechcombr/glpi:nginx-11.0.2`

## Quick Start

### Using Helm (Kubernetes)

#### Adding the Helm Repository

Add the GLPI Helm chart repository:

```sh
helm repo add glpi https://<owner>.github.io/<repo>
helm repo update
```

Replace `<owner>` with the GitHub organization/user name and `<repo>` with the repository name.

#### Installing the Chart

Install GLPI using Helm:

```sh
helm install my-glpi glpi/glpi
```

Or with custom values:

```sh
helm install my-glpi glpi/glpi -f custom-values.yaml
```

#### Searching for Available Versions

```sh
helm search repo glpi --versions
```

#### Upgrading the Chart

```sh
helm upgrade my-glpi glpi/glpi
```

#### Uninstalling the Chart

```sh
helm uninstall my-glpi
```

### Using Docker Compose

1. Clone this repository
2. Set up environment variables:
```sh
cp docker/.env.example docker/.env
```

## Credentials

    username: glpi
    password: glpi

## Variables

### docker-compose 

    ./docker/_env ---> please rename to /docker/.env


### kubernetes

    ./kubernetes/glpi-configmap.yaml
    ./kubernetes/glpi-secrets.yaml
    ./kubernetes/mariadb-configmap.yaml
    ./kubernetes/mariadb-secret.yaml 
    


## Helm Chart Publishing Workflow

This repository uses GitHub Actions to automatically validate, package, and publish the GLPI Helm chart to a chart repository hosted on GitHub Pages.

### Manually Triggering the Workflow

To publish a new version of the Helm chart:

1. Navigate to the **Actions** tab in the GitHub repository
2. Select the **Helm Chart CI/CD** workflow from the left sidebar
3. Click the **Run workflow** button (top right)
4. Configure the workflow parameters:
   - **Use workflow from**: Select the branch (typically `main`)
   - **Publish chart to repository**: Check this box to publish the chart, or uncheck to only validate and package
5. Click **Run workflow** to start the execution

### Publish Parameter

The `publish` input parameter controls whether the chart is published to the repository:

- **Checked (true)**: The workflow will lint, package, and publish the chart to GitHub Pages
- **Unchecked (false)**: The workflow will only lint and package the chart for validation purposes (useful for testing changes before publishing)

### Workflow Steps

The automated workflow performs the following steps:

1. **Lint**: Validates the Helm chart for syntax errors and best practices
2. **Package**: Creates a versioned `.tgz` archive of the chart
3. **Publish** (if enabled): Updates the chart repository index and deploys to GitHub Pages

### GitHub Pages Setup

Before the workflow can publish charts, GitHub Pages must be configured in your repository. Follow these steps to enable GitHub Pages:

#### Initial Setup Steps

1. Navigate to your repository on GitHub
2. Click on **Settings** (top navigation bar)
3. Scroll down to the **Pages** section in the left sidebar
4. Under **Source**, select:
   - **Deploy from a branch**
   - Branch: `gh-pages`
   - Folder: `/ (root)`
5. Click **Save**

**Note**: The `gh-pages` branch will be created automatically by the workflow on the first successful publish. If you haven't run the workflow yet, you can proceed with the setup - the branch will appear after the first workflow execution with publishing enabled.

#### Verifying GitHub Pages is Enabled

After running the workflow for the first time with publishing enabled, verify that GitHub Pages is working correctly:

1. Go to **Settings** → **Pages** in your repository
2. You should see a message: "Your site is live at `https://<owner>.github.io/<repo>/`"
3. Click the URL to verify the site is accessible
4. Navigate to `https://<owner>.github.io/<repo>/index.yaml` to confirm the chart repository index is available
5. The `index.yaml` file should contain metadata about your published chart(s)

#### Expected Results

Once GitHub Pages is properly configured and the workflow has run successfully:

- The `gh-pages` branch will exist in your repository
- The branch will contain:
  - `index.yaml` - Chart repository index file
  - `glpi-{version}.tgz` - Packaged chart archive(s)
- The chart repository will be accessible at: `https://<owner>.github.io/<repo>/`
- You can add the repository using: `helm repo add glpi https://<owner>.github.io/<repo>`

#### First-Time Publishing Checklist

Before running the workflow with publishing enabled for the first time:

- [ ] GitHub Pages is enabled in repository Settings → Pages
- [ ] Source is set to deploy from `gh-pages` branch
- [ ] Workflow permissions include `contents: write`, `pages: write`, and `id-token: write`
- [ ] Chart version in `kubernetes/glpi/Chart.yaml` is set correctly
- [ ] You have tested the workflow with `publish: false` to ensure linting and packaging work

After the first successful publish:

- [ ] Verify `gh-pages` branch was created
- [ ] Check that `index.yaml` exists at `https://<owner>.github.io/<repo>/index.yaml`
- [ ] Confirm the chart is listed: `helm search repo glpi` (after adding the repo)
- [ ] Test chart installation: `helm install test-glpi glpi/glpi --dry-run`

### Troubleshooting

#### Chart Not Appearing in Repository

**Problem**: After running the workflow, the chart is not available via `helm repo add`

**Solutions**:
- Verify that GitHub Pages is enabled in repository Settings → Pages
- Ensure the `gh-pages` branch exists and contains `index.yaml`
- Check that the workflow completed successfully without errors
- Wait a few minutes for GitHub Pages to deploy the changes
- Verify the repository URL is correct: `https://<owner>.github.io/<repo>`

#### Workflow Fails at Lint Step

**Problem**: The workflow fails with linting errors

**Solutions**:
- Review the error messages in the workflow logs
- Run `helm lint kubernetes/glpi` locally to see detailed errors
- Fix any syntax errors or missing required fields in Chart.yaml or template files
- Ensure all template files render correctly with default values

#### Workflow Fails at Publish Step

**Problem**: The workflow fails when trying to publish to GitHub Pages

**Solutions**:
- Verify that the workflow has the required permissions (contents: write, pages: write, id-token: write)
- Check that GitHub Pages is configured to deploy from the `gh-pages` branch
- Ensure the `GITHUB_TOKEN` has sufficient permissions
- Review the workflow logs for specific error messages

#### Version Already Exists

**Problem**: Attempting to publish a chart version that already exists

**Solutions**:
- Update the `version` field in `kubernetes/glpi/Chart.yaml` to a new version number
- Follow semantic versioning (MAJOR.MINOR.PATCH)
- Commit the version change before running the workflow

#### Cannot Add Helm Repository

**Problem**: `helm repo add` command fails or times out

**Solutions**:
- Verify the repository URL is correct and accessible in a browser
- Check that `index.yaml` exists at the repository root URL
- Ensure GitHub Pages is enabled and deployed
- Try removing and re-adding the repository: `helm repo remove glpi && helm repo add glpi <url>`

#### Chart Installation Fails

**Problem**: `helm install` fails after adding the repository

**Solutions**:
- Verify the chart name and version: `helm search repo glpi`
- Check that all required values are provided (review `values.yaml`)
- Run `helm install --dry-run --debug` to see what would be installed
- Review the error messages for missing dependencies or configuration issues

## About GLPI

GLPI stands for **Gestionnaire Libre de Parc Informatique** is a Free Asset and IT Management Software package, that provides ITIL Service Desk features, licenses tracking and software auditing.

https://github.com/glpi-project/glpi



## For Courses e-Learning

https://www.eftech.com.br


## For Support 

https://www.eftech.com.br
    
contato@eftech.com.br


## License

![license](https://img.shields.io/github/license/glpi-project/glpi.svg)

