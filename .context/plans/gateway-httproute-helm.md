---
status: ready
generated: 2026-10-16
agents:
  - type: "devops-specialist"
    role: "Design the Helm and Kubernetes resource implementation"
  - type: "feature-developer"
    role: "Implement chart values and templates"
  - type: "documentation-writer"
    role: "Document Gateway API and extraObject configuration"
  - type: "test-writer"
    role: "Validate rendered manifests and disabled defaults"
  - type: "security-auditor"
    role: "Review arbitrary manifest rendering risks and namespace handling"
phases:
  - id: "phase-1"
    name: "Plan and design"
    prevc: "P"
    agent: "devops-specialist"
  - id: "phase-2"
    name: "Implementation"
    prevc: "E"
    agent: "feature-developer"
  - id: "phase-3"
    name: "Validation and handoff"
    prevc: "V"
    agent: "test-writer"
---

# Gateway, HTTPRoute, and extraObject support

## Goal

Extend the GLPI Helm chart with optional Kubernetes Gateway API resources and a generic `extraObject` template. Existing Ingress support must remain backward compatible. The generic mechanism must allow operators to render arbitrary Kubernetes manifests, including Gateway API resources that need controller-specific fields.

## Current codebase context

- Chart: `helm/`
- Existing external exposure: `helm/templates/glpi-ingress.yaml`
- Existing values: `helm/values.yaml` under `ingress`
- Naming and labels: `helm/templates/_helpers.tpl`
- Validation commands: `helm lint helm` and `helm template <release> helm`
- No existing `extraObject` or `extraObjects` implementation was found.

## Design

1. Add an optional `gateway` values section for a `Gateway` resource and an optional `httpRoute` section for an `HTTPRoute` resource.
2. Add `helm/templates/glpi-gateway.yaml` and `helm/templates/glpi-httproute.yaml`, guarded by their respective `enabled` flags.
3. Route HTTP traffic to the chart's GLPI nginx Service using configurable service port, hostnames, listeners, parent references, matches, filters, and backend references. Provide sensible defaults while allowing raw lists/maps to be overridden.
4. Add an `extraObjects` values list and `helm/templates/extra-object.yaml`. Render each item as YAML, separated with `---`, and apply chart/release templating to values using `tpl` so users can reference release names and chart helpers.
5. Keep extra objects opt-in by default (`[]`). Do not mutate arbitrary objects' namespaces or fields; document that callers own validity and lifecycle of supplied manifests.
6. Define and document behavior when Ingress and Gateway API exposure are enabled together: both may render only when explicitly enabled, with no implicit deletion or replacement.

## Acceptance criteria

- Gateway and HTTPRoute are disabled by default and render valid Gateway API `v1` manifests when enabled.
- Rendered HTTPRoute references the configured Gateway and routes to the GLPI nginx Service.
- `extraObjects` can render one or more arbitrary Kubernetes objects, including templated values, with valid YAML document separators.
- Existing Ingress output is unchanged when Gateway API values are disabled.
- `helm lint` and representative `helm template` commands pass for defaults, Gateway API enabled, and extra objects enabled.
- README and values comments explain Gateway API CRD/controller prerequisites and extra object usage.

## Risks and mitigations

| Risk | Mitigation |
| --- | --- |
| Gateway API CRDs are not installed | Document prerequisite; Helm templates should still render locally because CRDs are cluster concerns. |
| Controller-specific Gateway fields vary | Expose listener and route structures as configurable values and support `extraObjects`. |
| Arbitrary object templating creates invalid YAML | Use `tpl` plus `toYaml`, document input shape, and validate with `helm template`. |
| Ingress and Gateway expose the same hostname | Do not silently reconcile; document that operators must avoid conflicting routes. |

## Work phases

### Plan

- Confirm chart Service name/port and existing Ingress behavior.
- Confirm Gateway API v1 resource fields against current upstream documentation.
- Link this plan and obtain workflow approval.

### Execute

- Add values and templates for Gateway and HTTPRoute.
- Add generic `extraObjects` values and template.
- Update README and values comments.

### Verify

- Run `helm lint helm`.
- Render defaults and enabled configurations with `helm template`.
- Assert disabled resources are absent and enabled resources contain expected names, references, and backend service ports.
- Review arbitrary object rendering for safe namespace and metadata behavior.

## Rollback

Revert the chart values, templates, and documentation changes. Since all new resources are disabled by default, an existing release remains unaffected unless operators explicitly enable the new values.

## Deliverables

- Gateway and HTTPRoute templates and values.
- `extra-object.yaml` template and `extraObjects` values documentation.
- Updated Helm README.
- Helm lint/template validation evidence.
