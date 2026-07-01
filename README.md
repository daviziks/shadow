# shadow

Declarative NixOS and home-manager configuration for the `shadow` machine.

## Targets

- `nixosConfigurations.shadow`: the real bare-metal machine.
- `nixosConfigurations.shadow-vm`: a lightweight VM target for testing the base system and toolchain before reinstalling bare metal.

## Workflow

```sh
just check
just build-vm
just run-vm
```

On Fedora Silverblue, direct host Nix installation is blocked by composefs/rpm-ostree constraints, so VM testing is done through a `nixos/nix` Podman container as documented in [docs/migration.md](docs/migration.md).

## Design Notes

- Stable NixOS base with selected unstable desktop/dev packages.
- KDE Plasma, Chrome, VS Code, and Ghostty as the GUI surface.
- Rootless Podman with Docker-compatible CLI/socket.
- `/home/daviziks/dev` is backed by the dedicated `easy` SSD.
- Task/dev tooling will be built from `just` plus POSIX scripts first, with a custom app only if the workflow earns it.

## Task Workflow

Tasks live under `/home/daviziks/dev/<task-slug>`, with repos directly inside the task directory. Git mirrors are cached under `/home/daviziks/dev/.cache/git`, while package caches live under `/home/daviziks/dev/.cache/pkg`.

```sh
just task-new fixing-mfe-auth-issue org/sigla-web org/sigla-api@develop=fixing-mfe-auth-issue
just task-pick exp-ast-grep-tool daviziks
just task-shell fixing-mfe-auth-issue
just task-podman fixing-mfe-auth-issue ps
just task-destroy fixing-mfe-auth-issue
```

Inside `just task-shell`, `podman` and `docker` resolve to task-local wrappers. Images, containers, volumes, run state, and the default run/create network stay task-scoped, while host port publishing is refused so parallel tasks do not collide.

See [docs/task-workflow.md](docs/task-workflow.md) for the full command reference.
