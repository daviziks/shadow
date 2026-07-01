# Task workflow

The dev workspace is task-first:

```text
/home/daviziks/dev/<task-slug>/<repo>
```

The command is `devel`.

## 1. Add repos to the store

Add the repos you commonly work with once:

```sh
devel store add sigla/sigla-web sigla/sigla-api daviziks/some-tool
```

You can list or remove stored repos:

```sh
devel store list
devel store rm sigla/sigla-api
```

The store lives at:

```text
/home/daviziks/dev/.devel/repos.tsv
```

## 2. Create a task

Create a task and select repos interactively from the store:

```sh
devel create fixing-mfe-auth-issue
```

This opens `fzf` with multi-select. The selected repos are cloned into:

```text
/home/daviziks/dev/fixing-mfe-auth-issue/<repo>
```

You can still pass repos explicitly when needed:

```sh
devel create exp-ast-grep-tool sigla/sigla-web@develop daviziks/ast-tool@main=exp-ast-grep-tool
```

Repo spec format:

```text
owner/repo              clone the repo default branch
owner/repo@develop      clone from develop
owner/repo@main=fix-x   clone from main, then create/switch local branch fix-x
```

## 3. Enter the task

```sh
cd $(devel path fixing-mfe-auth-issue)
devel enter fixing-mfe-auth-issue
```

Inside the task shell, `podman` and `docker` are task-local wrappers. You do not normally call `devel podman` or `devel docker`; just use the normal commands from inside the task shell. Their storage, runroot, and container network are isolated per task, and host port publishing is blocked to avoid collisions.

## 4. Cleanup

Delete one task:

```sh
devel destroy fixing-mfe-auth-issue
```

Delete all task directories and task-local container state:

```sh
devel prune
```

Shared git/package caches and the repo store are preserved.

## 5. Cache refresh

Refresh all stored repo mirrors:

```sh
devel cache update
```

Refresh specific repos:

```sh
devel cache update sigla/sigla-web sigla/sigla-api
```
