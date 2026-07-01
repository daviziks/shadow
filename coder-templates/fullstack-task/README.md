# fullstack-task

Coder template for Shadow task workspaces.

Parameters:

- `repo_specs`: whitespace-separated specs such as `owner/repo@main=fix-abc`.
- `service_profile`: metadata label for the service stack you expect to use.

The container includes Node 24, Bun, pnpm, Go, GitHub CLI, Docker CLI, Docker
Compose v2, Playwright browsers, ripgrep, fd, fzf, jq, and build tooling.

The workspace mounts Shadow's Podman socket as `/var/run/docker.sock`, so Docker
CLI commands inside the workspace target the Shadow Podman runtime.
MD
