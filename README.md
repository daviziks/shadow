# shadow

Declarative NixOS configuration for the `shadow` headless dev server.

## Apply changes

```sh
cd /etc/nixos
sudo nixos-rebuild switch --flake .#shadow
```

## Remote workflow

Shadow is a headless NixOS dev server reached over SSH/Tailscale. The host keeps
Codex, common development tools, Podman, and Herdr available system-wide.

`/home/daviziks/dev` is reserved for local development state, package caches,
and container storage. Task/workspace orchestration is intentionally no longer
declared in this repo.

Connect directly when away from the PC:

```sh
ssh shadow
herdr
```

## Codex SSH host

Codex CLI is installed system-wide as `codex`. To use Shadow from the Codex app,
make sure this SSH host is in your local `~/.ssh/config`, then run
`codex login` once as `daviziks` on Shadow.

## Headless profile

The `shadow` host is intentionally headless. KDE, Sunshine, local GUI apps,
printing, Avahi, and persistent browser containers are not part of the server
profile.

`agent-workspace-linux` is installed for isolated, throwaway AI browser/GUI
workspaces without restoring a host desktop session.
