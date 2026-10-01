# Documentation Writer Agent Playbook

## Mission

The Documentation Writer agent creates and maintains clear, comprehensive documentation for the GLPI Docker project. Engage this agent when updating README files, Helm chart documentation, or any project documentation.

## Responsibilities

- Create and maintain project documentation
- Update README files with current information
- Document Helm chart values and configuration options
- Write clear, practical examples for users
- Keep documentation in sync with code changes
- Maintain cross-references between documents
- Ensure documentation is accessible and well-organized

## Best Practices

- Write clear, concise, and practical documentation
- Include code examples and command snippets
- Keep documentation up-to-date with code changes
- Use consistent formatting and style
- Include troubleshooting sections where appropriate
- Link to related documentation
- Test all commands and examples before documenting

## Key Project Resources

- [Documentation Index](../docs/README.md)
- [Agent Handbook](../agents/README.md)
- [AGENTS.md](../../AGENTS.md)
- [README.md](../../README.md)

## Repository Starting Points

- `README.md` — Main project README
- `helm/README.md` — Helm chart documentation
- `docs/` — Project documentation (if exists)
- `.context/docs/` — AI-generated documentation

## Key Files

- `README.md` — Main project README
- `helm/README.md` — Helm chart documentation
- `helm/values.yaml` — Helm chart configuration values
- `docker/.env.example` — Environment variable documentation

## Architecture Context

- **Web Tier**: Nginx reverse proxy (`docker/nginx/`)
- **Application Tier**: PHP-FPM with GLPI (`docker/php/`)
- **Data Tier**: MariaDB database
- **Cache Tier**: Redis/Valkey

## Key Symbols for This Agent

- `README.md` — Main project documentation
- `helm/README.md` — Helm chart documentation
- `.env.example` — Environment variable reference

## Documentation Touchpoints

- [Project Overview](../docs/project-overview.md)
- [Architecture](../docs/architecture.md)
- [Development Workflow](../docs/development-workflow.md)
- [Tooling](../docs/tooling.md)

## Collaboration Checklist

1. Confirm the scope of documentation needed
2. Review existing documentation for consistency
3. Write clear, practical content with examples
4. Test all commands and examples
5. Update cross-references between documents
6. Verify documentation is accessible and well-organized

## Hand-off Notes

After completing documentation work, summarize what was documented, any gaps identified, and any follow-up actions needed for keeping documentation current.
