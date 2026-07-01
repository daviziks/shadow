# Shadow dev platform roadmap

This roadmap tracks the migration from a GUI workstation into a headless,
task-first development server.

## Target stack

- NixOS owns the base system, disks, services, firewall, and rollback path.
- Coder owns long-lived development workspaces and VS Code/SSH entrypoints.
- `devel` remains the human-facing task CLI and can wrap Coder over time.
- Kasm owns the persistent work browser for corporate accounts and meetings.
- `agent-workspace-linux` owns isolated GUI/browser automation for AI agents.
- Podman/Docker Compose service profiles own per-task dependencies.
- Tailscale and Caddy expose services only to the tailnet.

## Issue sequence

1. #1 Headless baseline for Shadow
2. #2 Mount and use backup HDD
3. #3 Install and expose Coder for dev workspaces
4. #4 Create fullstack Coder workspace template
5. #5 DevL/devel v2 task CLI
6. #6 Kasm work browser with persistent corporate profile
7. #7 Per-task debug browser and app routing
8. #8 Agent workspace Linux integration
9. #9 Service profile library for task dependencies

## Delivery phases

### Phase 1: Server foundation

Make the machine boring and reliable first. The headless profile, backup disk,
service directories, firewall, Tailscale access, and rollback notes should land
before adding new orchestration services.

### Phase 2: Workspace control plane

Add Coder and the first fullstack workspace template. The first version should
prove repo selection, branch selection, VS Code Desktop access, and a basic
Node/Bun/Go/Playwright toolchain.

### Phase 3: Human workflow

Evolve `devel` into the workflow command for Linear-driven tasks. It should
eventually create workspaces, record task metadata, open useful URLs, start
service profiles, and help with PR/status updates.

### Phase 4: Browser surfaces

Add the persistent work browser separately from per-task debug browsers. The
work browser must optimize for stable corporate logins and meeting media. The
task browser must optimize for reaching task-local services without port
collisions.

### Phase 5: Agent workspace

Install `agent-workspace-linux` under a dedicated user with a permission
ceiling. Wire it to the executor only after the local doctor/start/browser
checks work.

## Current baseline

- `/home/daviziks/dev` is mounted from the dev-state SSD.
- `/etc/nixos` is a Git repository and `nix flake check --no-build` passes.
- `devel` already supports a repo store, task creation, task shells, and
  task-local Podman/Docker wrappers.
- Tailscale, Caddy, Podman, SSH, and the executor service are already enabled.
- KDE/Sunshine/printing/Avahi are still enabled and should move behind a
  desktop profile or be removed for the headless target.

## Non-goals for the first PRs

- Do not replace `devel` with Coder in one step.
- Do not expose any new service outside Tailscale.
- Do not store corporate browser credentials in disposable task workspaces.
- Do not give AI agent workspaces broad host mounts by default.
