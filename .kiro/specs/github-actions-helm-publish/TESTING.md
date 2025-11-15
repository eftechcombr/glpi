# Workflow Validation Tests

This document provides comprehensive testing procedures for the Helm Chart CI/CD workflow. Follow these procedures to validate the workflow before and after deployment.

## Prerequisites

Before running any tests, ensure:
- You have write access to the repository
- GitHub Actions is enabled for the repository
- The Helm chart exists at `kubernetes/glpi/`
- Chart.yaml contains a valid version field

## Test Suite Overview

This test suite covers:
1. Lint-only execution (publish: false)
2. Full publish execution (publish: true)
3. Error handling scenarios
4. End-to-end validation

---

## Test 1: Lint-Only Execution (Validation Mode)

**Purpose**: Verify that the workflow can validate Helm charts without publishing

**Requirements Tested**: 1.1, 1.2

### Setup
1. Navigate to the GitHub repository
2. Go to Actions tab
3. Select "Helm Chart CI/CD" workflow

### Test Steps

#### Step 1: Trigger Workflow with Publish Disabled
1. Click "Run workflow" button
2. Select branch: `main` (or your working branch)
3. Set "Publish chart to repository" to **false** (uncheck the box)
4. Click "Run workflow"

#### Step 2: Monitor Workflow Execution
1. Click on the running workflow to view details
2. Observe the jobs panel on the left

### Expected Outputs

#### Job Execution
- ✅ **lint** job should start and complete
- ✅ **package** job should start and complete
- ⏭️ **publish** job should be **skipped** (grayed out)

#### Lint Job Output
```
Run helm lint kubernetes/glpi
==> Linting kubernetes/glpi
[INFO] Chart.yaml: icon is recommended
1 chart(s) linted, 0 chart(s) failed
```

#### Package Job Output
```
Chart version: X.Y.Z
Packaged chart: glpi-X.Y.Z.tgz
Successfully packaged chart and saved it to: .cr-release-packages/glpi-X.Y.Z.tgz
```

#### Artifacts
- ✅ Workflow artifact "helm-chart-package" should be available for download
- ✅ Artifact should contain `glpi-X.Y.Z.tgz` file

### Verification Steps

1. **Verify Lint Job Success**
   - Check that lint job shows green checkmark
   - Confirm no linting errors in logs
   - Verify chart directory was found and processed

2. **Verify Package Job Success**
   - Check that package job shows green checkmark
   - Confirm chart version was extracted correctly
   - Verify package was created in `.cr-release-packages/` directory

3. **Verify Publish Job Skipped**
   - Confirm publish job shows "skipped" status
   - Verify no changes were made to gh-pages branch
   - Confirm no new commits in repository

4. **Download and Inspect Artifact**
   - Click on "helm-chart-package" artifact
   - Download and extract the .tgz file
   - Verify it contains valid Helm chart structure:
     - Chart.yaml
     - values.yaml
     - templates/ directory

### Success Criteria
- [x] All three jobs appear in workflow (lint, package, publish)
- [x] Lint job completes successfully
- [x] Package job completes successfully
- [-] Publish job is skipped
- [ ] Workflow completes with green status
- [ ] Artifact is available and contains valid chart package
- [ ] No changes to gh-pages branch
- [ ] Total execution time < 5 minutes

---

## Test 2: Full Publish Execution

**Purpose**: Verify complete workflow including chart publishing to GitHub Pages

**Requirements Tested**: 1.1, 1.2, 2.1, 3.1

### Setup
1. Ensure GitHub Pages is configured (or will be auto-configured)
2. Navigate to Actions tab
3. Select "Helm Chart CI/CD" workflow

### Test Steps

#### Step 1: Trigger Workflow with Publish Enabled
1. Click "Run workflow" button
2. Select branch: `main`
3. Set "Publish chart to repository" to **true** (check the box)
4. Click "Run workflow"

#### Step 2: Monitor Workflow Execution
1. Click on the running workflow
2. Watch all three jobs execute in sequence

### Expected Outputs

#### Job Execution Sequence
- ✅ **lint** job runs first
- ✅ **package** job runs after lint succeeds
- ✅ **publish** job runs after package succeeds

#### Lint Job Output
```
Run helm lint kubernetes/glpi
==> Linting kubernetes/glpi
[INFO] Chart.yaml: icon is recommended
1 chart(s) linted, 0 chart(s) failed
```

#### Package Job Output
```
Chart version: X.Y.Z
Packaged chart: glpi-X.Y.Z.tgz
Successfully packaged chart and saved it to: .cr-release-packages/glpi-X.Y.Z.tgz
```

#### Publish Job Output
```
Run helm/chart-releaser-action@v1.6.0
====> Using existing chart package: glpi-X.Y.Z.tgz
====> Updating index.yaml
====> Pushing changes to gh-pages branch
====> Chart successfully published
```

### Verification Steps

1. **Verify All Jobs Completed**
   - Check that all three jobs show green checkmarks
   - Confirm no errors in any job logs
   - Verify jobs ran in correct sequence

2. **Verify gh-pages Branch Created/Updated**
   - Navigate to repository branches
   - Confirm `gh-pages` branch exists
   - Check latest commit message (should reference chart release)
   - Verify commit author is GitHub Actions bot

3. **Verify Chart Files Published**
   - Switch to `gh-pages` branch
   - Confirm `index.yaml` file exists
   - Confirm `glpi-X.Y.Z.tgz` file exists
   - Check that index.yaml contains chart metadata

4. **Verify index.yaml Content**
   ```yaml
   apiVersion: v1
   entries:
     glpi:
       - name: glpi
         version: X.Y.Z
         appVersion: "..."
         description: GLPI - IT Asset Management and Service Desk
         urls:
           - https://{owner}.github.io/{repo}/glpi-X.Y.Z.tgz
         created: 2025-11-15T...
         digest: sha256:...
   ```

5. **Verify GitHub Pages Deployment**
   - Go to Settings → Pages
   - Confirm Pages is enabled and deploying from gh-pages branch
   - Note the published URL: `https://{owner}.github.io/{repo}/`
   - Wait for Pages deployment to complete (check Actions tab for pages-build-deployment)

6. **Verify Chart Repository Accessibility**
   ```bash
   # Test index.yaml is accessible
   curl -I https://{owner}.github.io/{repo}/index.yaml
   # Should return: HTTP/2 200
   
   # Test chart package is accessible
   curl -I https://{owner}.github.io/{repo}/glpi-X.Y.Z.tgz
   # Should return: HTTP/2 200
   ```

### Success Criteria
- [ ] All three jobs complete successfully
- [ ] gh-pages branch created or updated
- [ ] index.yaml file contains correct chart metadata
- [ ] Chart .tgz file is present in gh-pages branch
- [ ] GitHub Pages deployment succeeds
- [ ] index.yaml is accessible via HTTPS
- [ ] Chart package is accessible via HTTPS
- [ ] Total execution time < 10 minutes

---

## Test 3: Chart Installation from Published Repository

**Purpose**: Verify that published charts can be installed using Helm

**Requirements Tested**: 3.1

### Prerequisites
- Test 2 (Full Publish Execution) completed successfully
- Helm 3.x installed locally
- kubectl configured (optional, for actual installation)

### Test Steps

#### Step 1: Add Helm Repository
```bash
helm repo add glpi-test https://{owner}.github.io/{repo}/
```

**Expected Output**:
```
"glpi-test" has been added to your repositories
```

#### Step 2: Update Repository Cache
```bash
helm repo update
```

**Expected Output**:
```
Hang tight while we grab the latest from your chart repositories...
...Successfully got an update from the "glpi-test" chart repository
Update Complete. ⎈Happy Helming!⎈
```

#### Step 3: Search for Chart
```bash
helm search repo glpi-test
```

**Expected Output**:
```
NAME              CHART VERSION  APP VERSION  DESCRIPTION
glpi-test/glpi    X.Y.Z          ...          GLPI - IT Asset Management and Service Desk
```

#### Step 4: Show Chart Information
```bash
helm show chart glpi-test/glpi
```

**Expected Output**:
```yaml
apiVersion: v2
name: glpi
version: X.Y.Z
appVersion: "..."
description: GLPI - IT Asset Management and Service Desk
...
```

#### Step 5: Template Chart (Dry Run)
```bash
helm template test-release glpi-test/glpi
```

**Expected Output**:
- Valid Kubernetes YAML manifests
- No template errors
- All resources render correctly

#### Step 6: Install Chart (Optional)
```bash
# Only if you have a Kubernetes cluster available
helm install test-glpi glpi-test/glpi --dry-run --debug
```

**Expected Output**:
- Installation plan displayed
- No errors in template rendering
- All resources validated

### Verification Steps

1. **Verify Repository Addition**
   - Confirm repository added without errors
   - Check repository list: `helm repo list`

2. **Verify Chart Discovery**
   - Confirm chart appears in search results
   - Verify version matches Chart.yaml
   - Check description is correct

3. **Verify Chart Metadata**
   - Confirm all required fields present
   - Verify version format is semantic versioning
   - Check appVersion is set

4. **Verify Template Rendering**
   - Confirm templates render without errors
   - Check all expected resources are generated
   - Verify no syntax errors in output

### Success Criteria
- [ ] Repository added successfully
- [ ] Chart found in search results
- [ ] Chart metadata is complete and correct
- [ ] Templates render without errors
- [ ] Chart can be installed (dry-run succeeds)

---

## Test 4: Error Handling - Invalid Chart

**Purpose**: Verify workflow fails gracefully when chart has errors

**Requirements Tested**: 1.2

### Setup
1. Create a test branch: `git checkout -b test-invalid-chart`
2. Introduce an error in the Helm chart

### Test Steps

#### Step 1: Introduce Linting Error
Edit `kubernetes/glpi/Chart.yaml` and introduce an error:
```yaml
# Remove or corrupt the version field
version: invalid.version.format
```

Or introduce a template error in any template file:
```yaml
# Add invalid template syntax
{{ .Values.nonexistent | invalid }}
```

#### Step 2: Commit and Push
```bash
git add kubernetes/glpi/Chart.yaml
git commit -m "test: introduce linting error"
git push origin test-invalid-chart
```

#### Step 3: Trigger Workflow
1. Go to Actions tab
2. Run workflow on `test-invalid-chart` branch
3. Set publish to false

### Expected Outputs

#### Lint Job Failure
```
Run helm lint kubernetes/glpi
==> Linting kubernetes/glpi
[ERROR] Chart.yaml: version 'invalid.version.format' is not a valid SemVer
Error: 1 chart(s) linted, 1 chart(s) failed
```

#### Workflow Status
- ❌ **lint** job fails with red X
- ⏭️ **package** job is skipped
- ⏭️ **publish** job is skipped
- ❌ Overall workflow status: Failed

### Verification Steps

1. **Verify Lint Failure**
   - Confirm lint job shows failure status
   - Check error message is clear and actionable
   - Verify error indicates specific problem

2. **Verify Subsequent Jobs Skipped**
   - Confirm package job did not run
   - Confirm publish job did not run
   - Verify no artifacts created

3. **Verify No Publishing Occurred**
   - Check gh-pages branch unchanged
   - Confirm no new commits
   - Verify index.yaml not updated

### Cleanup
```bash
git checkout main
git branch -D test-invalid-chart
git push origin --delete test-invalid-chart
```

### Success Criteria
- [ ] Lint job fails with clear error message
- [ ] Subsequent jobs are skipped
- [ ] Workflow marked as failed
- [ ] No chart published
- [ ] Error message helps identify the problem

---

## Test 5: Multiple Version Publishing

**Purpose**: Verify that multiple chart versions can coexist in the repository

**Requirements Tested**: 3.1

### Test Steps

#### Step 1: Publish First Version
1. Ensure Chart.yaml has version `1.0.0`
2. Run workflow with publish enabled
3. Verify successful publication

#### Step 2: Update Chart Version
1. Edit `kubernetes/glpi/Chart.yaml`
2. Change version to `1.0.1`
3. Commit changes: `git commit -am "chore: bump chart version to 1.0.1"`
4. Push to main branch

#### Step 3: Publish Second Version
1. Run workflow with publish enabled
2. Verify successful publication

#### Step 4: Verify Both Versions Available
```bash
helm repo update
helm search repo glpi-test --versions
```

**Expected Output**:
```
NAME              CHART VERSION  APP VERSION  DESCRIPTION
glpi-test/glpi    1.0.1          ...          GLPI - IT Asset Management...
glpi-test/glpi    1.0.0          ...          GLPI - IT Asset Management...
```

### Verification Steps

1. **Verify index.yaml Contains Both Versions**
   - Check gh-pages branch
   - Open index.yaml
   - Confirm two entries under `glpi` key

2. **Verify Both Packages Exist**
   - Check gh-pages branch contains:
     - `glpi-1.0.0.tgz`
     - `glpi-1.0.1.tgz`

3. **Verify Installation of Specific Version**
   ```bash
   # Install older version
   helm template test glpi-test/glpi --version 1.0.0
   
   # Install newer version
   helm template test glpi-test/glpi --version 1.0.1
   ```

### Success Criteria
- [ ] Both versions listed in search results
- [ ] index.yaml contains both version entries
- [ ] Both .tgz files present in gh-pages
- [ ] Can install either version explicitly
- [ ] Latest version installed by default

---

## Troubleshooting Guide

### Issue: Workflow Doesn't Appear in Actions Tab

**Symptoms**: Workflow file exists but doesn't show in GitHub Actions

**Solutions**:
1. Verify workflow file is in `.github/workflows/` directory
2. Check YAML syntax is valid
3. Ensure file has `.yml` or `.yaml` extension
4. Push workflow file to default branch first
5. Check GitHub Actions is enabled in repository settings

### Issue: Lint Job Fails

**Symptoms**: Lint job shows errors

**Solutions**:
1. Run `helm lint kubernetes/glpi` locally to see errors
2. Check Chart.yaml has all required fields
3. Verify version follows semantic versioning (X.Y.Z)
4. Ensure all template files have valid syntax
5. Check values.yaml is valid YAML

### Issue: Package Job Fails to Extract Version

**Symptoms**: "Chart version:" shows empty or error

**Solutions**:
1. Verify Chart.yaml has `version:` field
2. Check version field format: `version: 1.0.0` (with space after colon)
3. Ensure Chart.yaml is valid YAML
4. Check file encoding is UTF-8

### Issue: Publish Job Fails

**Symptoms**: chart-releaser-action reports errors

**Solutions**:
1. Verify GitHub Pages is enabled
2. Check workflow has correct permissions
3. Ensure GITHUB_TOKEN has write access
4. Verify gh-pages branch isn't protected
5. Check chart version doesn't already exist (if not using skip_existing)

### Issue: Chart Not Accessible After Publishing

**Symptoms**: 404 errors when accessing chart or index.yaml

**Solutions**:
1. Wait 2-5 minutes for GitHub Pages deployment
2. Check Pages deployment in Actions tab
3. Verify Pages source is set to gh-pages branch
4. Check repository visibility (public vs private)
5. Verify URL format: `https://{owner}.github.io/{repo}/`

### Issue: Helm Repo Add Fails

**Symptoms**: Cannot add repository or 404 on index.yaml

**Solutions**:
1. Verify GitHub Pages deployment completed
2. Check URL is correct (no trailing slash)
3. Ensure index.yaml exists in gh-pages branch
4. Test URL in browser first
5. Check repository is public (or configure authentication)

---

## Continuous Testing Recommendations

### Before Each Release
- [ ] Run lint-only test on feature branch
- [ ] Fix any linting errors
- [ ] Merge to main branch
- [ ] Run full publish test
- [ ] Verify chart installation

### After Workflow Changes
- [ ] Test lint-only execution
- [ ] Test full publish execution
- [ ] Verify error handling still works
- [ ] Check all jobs execute in correct order

### Monthly Validation
- [ ] Verify all published versions still accessible
- [ ] Test chart installation from repository
- [ ] Check GitHub Pages deployment status
- [ ] Review workflow execution times

---

## Test Execution Log Template

Use this template to document test execution results:

```
Test Date: YYYY-MM-DD
Tester: [Name]
Branch: [branch-name]
Chart Version: [X.Y.Z]

Test 1: Lint-Only Execution
- Status: [ ] Pass [ ] Fail
- Notes: 

Test 2: Full Publish Execution
- Status: [ ] Pass [ ] Fail
- Notes:

Test 3: Chart Installation
- Status: [ ] Pass [ ] Fail
- Notes:

Test 4: Error Handling
- Status: [ ] Pass [ ] Fail
- Notes:

Test 5: Multiple Versions
- Status: [ ] Pass [ ] Fail
- Notes:

Overall Result: [ ] All Tests Passed [ ] Some Tests Failed
Action Items:
-
-
```
