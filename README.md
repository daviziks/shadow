# shadow

Declarative NixOS configuration for the `shadow` headless dev server.

## Apply changes

```sh
cd /etc/nixos
sudo nixos-rebuild switch --flake .#shadow
```

## Dev workflow

Use `devel` for task-first development environments.

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

Create a Coder workspace for remote VS Code workflows:

```sh
devel coder create fixing-mfe-auth-issue --profile sqlserver-minio-centrifugo sigla/sigla-web@develop=fix-auth
```

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

## Headless profile

The `shadow` host is intentionally headless. KDE, Sunshine, local GUI apps,
printing, Avahi, and persistent browser containers are not part of the server
profile.

`agent-workspace-linux` is installed for isolated, throwaway AI browser/GUI
workspaces without restoring a host desktop session.
