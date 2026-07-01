# shadow

Declarative NixOS configuration for the `shadow` headless dev server.

## Apply changes

```sh
cd /etc/nixos
sudo nixos-rebuild switch --flake .#shadow
```

## Dev workflow

Use `shadow-ws` for isolated task workspaces that Codex App can reach over SSH.

Create a container workspace:

```sh
shadow-ws create fixing-mfe-auth-issue \
  --repo sigla/sigla-web@develop=fixing-mfe-auth-issue \
  --repo sigla/sigla-api@main=fixing-mfe-auth-issue \
  --profile sqlserver-minio-centrifugo
```

The command prints a concrete SSH alias. Add it to your Windows
`~/.ssh/config`, then add that alias as an SSH host in Codex App and select
`/workspace`.

When you are away from the PC, connect with SSH/Herdr:

```sh
ssh shadow-fixing-mfe-auth-issue
herdr
```

`devel` remains available for host-side task folders while `shadow-ws` becomes
the main Codex App workflow.

Add repos once:

```sh
devel store add sigla/sigla-web sigla/sigla-api
```

Create a task by selecting stored repos with `fzf`:

```sh
devel create fixing-mfe-auth-issue
cd $(devel path fixing-mfe-auth-issue)
devel enter fixing-mfe-auth-issue
```

Inside the task shell, normal `podman`/`docker` commands use task-local storage and networking. Host port publishing is blocked so parallel tasks do not collide.

Service profiles are available from `/etc/shadow-dev/service-profiles`:

```sh
devel profile list
```

Cleanup:

```sh
devel destroy fixing-mfe-auth-issue
devel prune
```

See `docs/task-workflow.md` for details.

## Codex SSH host

Codex CLI is installed system-wide as `codex`. To use Shadow from the Codex app,
make sure this SSH host is in your local `~/.ssh/config`, then run
`codex login` once as `daviziks` on Shadow.

The primary remote workflow is moving to per-task SSH workspace containers, so
each Codex App chat can target a concrete isolated host alias.

## Headless profile

The `shadow` host is intentionally headless. KDE, Sunshine, local GUI apps,
printing, Avahi, and persistent browser containers are not part of the server
profile.

`agent-workspace-linux` is installed for isolated, throwaway AI browser/GUI
workspaces without restoring a host desktop session.
