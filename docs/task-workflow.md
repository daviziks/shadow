# Task Workflow

The dev layout is task-first:

```text
/home/daviziks/dev/<task-slug>/<repo>
```

Shared state lives outside individual repos:

- `/home/daviziks/dev/.cache/git`: bare Git mirrors, one per GitHub repo.
- `/home/daviziks/dev/.cache/pkg`: shared package caches for Bun, npm, and Corepack.
- `/home/daviziks/dev/<task>/.shadow`: task metadata, wrappers, Podman graphroot, and Podman run state.

## Creating Tasks

Create a task from explicit repo specs:

```sh
just task-new fixing-mfe-auth-issue org/sigla-web org/sigla-api@develop=fixing-mfe-auth-issue
```

Pick repos interactively with `fzf` from a GitHub owner/user:

```sh
just task-pick exp-ast-grep-tool daviziks
```

Repo spec format:

```text
owner/repo              clone the repo default branch
owner/repo@develop      clone from develop
owner/repo@main=fix-x   clone from main, then create/switch local branch fix-x
```

If no branch is provided, the script asks GitHub for the repo default branch. It uses HTTPS clone URLs by default so Fedora/NixOS SSH key setup does not block repo creation.

## Working Inside A Task

Enter a task shell:

```sh
just task-shell fixing-mfe-auth-issue
```

That shell prepends task-local `podman` and `docker` wrappers to `PATH`. Those wrappers keep containers, images, volumes, and run state under the task's `.shadow` directory. Host port publishing is blocked: `-p`, `--publish`, and `-P` fail fast. Compose files, including files passed with `-f`/`--file`, are rejected when they contain a top-level `ports:` section. Container network selection is managed by the wrapper, and `podman run`/`podman create` are automatically attached to the task network.

```sh
podman info --format '{{ .Store.GraphRoot }}'
docker ps
```

Create or print the task's private Podman network:

```sh
just task-network fixing-mfe-auth-issue
```

Run a task-local Podman command without entering the shell:

```sh
just task-podman fixing-mfe-auth-issue ps
just task-docker fixing-mfe-auth-issue compose ps
```

## Cleanup

Delete a task and its task-local container state:

```sh
just task-destroy fixing-mfe-auth-issue
```

The shared Git mirror cache is intentionally kept. Remove or refresh caches explicitly when needed:

```sh
just task-cache-update org/sigla-web org/sigla-api
```
