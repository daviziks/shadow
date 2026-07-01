# Shadow dev platform roadmap

This roadmap tracks the migration from a GUI workstation into a headless,
task-first development server.

## Target stack

- NixOS owns the base system, disks, services, firewall, and rollback path.
- Per-task SSH containers own long-lived development workspaces and Codex App entrypoints.
- `devel` remains the human-facing task CLI until `shadow-ws` replaces it.
- Herdr owns persistent terminal sessions and agent panes over SSH.
- `agent-workspace-linux` owns isolated GUI/browser automation for AI agents.
- Podman/Docker Compose service profiles own per-task dependencies.
- Tailscale and Caddy expose services only to the tailnet.

## Issue sequence

1. #1 Headless baseline for Shadow
2. #2 Mount and use backup HDD
3. #5 DevL/devel v2 task CLI
4. #7 Per-task debug browser and app routing
5. Herdr terminal/session multiplexer
6. #8 Agent workspace Linux integration
7. #9 Service profile library for task dependencies
8. Per-task SSH workspace containers for Codex App

## Delivery phases

### Phase 1: Server foundation

Make the machine boring and reliable first. The headless profile, backup disk,
service directories, firewall, Tailscale access, and rollback notes should land
before adding new orchestration services.

### Phase 2: Workspace control plane

Add per-task SSH workspace containers. The first version should prove repo
selection, branch selection, Codex App SSH access, Herdr access, and a basic
Node/Bun/Go/Playwright toolchain.

### Phase 3: Human workflow

Evolve `devel` into the workflow command for Linear-driven tasks. It should
eventually create workspaces, record task metadata, open useful URLs, start
service profiles, and help with PR/status updates.

### Phase 4: Terminal and Browser Surfaces

Use Herdr for persistent SSH terminal sessions and agent panes. Per-task debug
browser support should stay scoped to workspaces and agent automation rather
than a persistent corporate browser on Shadow.

### Phase 5: Agent workspace

Install `agent-workspace-linux` with a permission ceiling profile. Wire it to
the executor only after the local doctor/start/browser checks work.

## Current baseline

- `/home/daviziks/dev` is mounted from the dev-state SSD.
- `/etc/nixos` is a Git repository and `nix flake check --no-build` passes.
- `devel` already supports a repo store, task creation, task shells, and
  task-local Podman/Docker wrappers.
- Tailscale, Caddy, Podman, SSH, and the executor service are already enabled.
- KDE/Sunshine/printing/Avahi and persistent browser containers are removed
  from the headless profile.

## Non-goals for the first PRs

- Do not introduce a heavyweight workspace control plane before the SSH-container workflow proves itself.
- Do not expose any new service outside Tailscale.
- Do not store corporate browser credentials on Shadow.
- Do not give AI agent workspaces broad host mounts by default.
