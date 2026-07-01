# shadow

Declarative NixOS configuration for the `shadow` workstation.

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

Cleanup:

```sh
devel destroy fixing-mfe-auth-issue
devel prune
```

See `docs/task-workflow.md` for details.
