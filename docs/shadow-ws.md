# Shadow Workspaces

`shadow-ws` creates one SSH-addressable Podman container per task. The Codex App
can connect to each workspace through a concrete SSH alias, while Herdr or plain
SSH can connect from a terminal.

Create a workspace:

```sh
shadow-ws create fix-auth \
  --repo octocat/Hello-World \
  --repo agent-sh/agent-workspace-linux \
  --profile sqlserver-minio-centrifugo
```

The command prints a block for your Windows `~/.ssh/config`:

```sshconfig
Host shadow-fix-auth
  HostName 127.0.0.1
  User coder
  Port 22200
  ProxyJump shadow
  StrictHostKeyChecking accept-new
```

Add the printed alias to the Windows SSH config, verify it:

```powershell
ssh shadow-fix-auth
```

Then open Codex App settings, add the SSH host alias, and select `/workspace`
or one of the cloned repos under `/workspace`.

Other commands:

```sh
shadow-ws list
shadow-ws ssh-config
shadow-ws enter fix-auth
shadow-ws stop fix-auth
shadow-ws start fix-auth
shadow-ws destroy fix-auth
```

Inside the container, `codex`, `pi`, `node`, `bun`, `go`, and `herdr` are exposed
from Shadow's Nix profile through `/host-sw/bin`.

## Agent Workspace Linux MCP

Agent Workspace Linux is exposed for Executor through a local Supergateway bridge.

- Host MCP URL: `http://127.0.0.1:4789/mcp`
- Executor-container MCP URL: `http://10.88.0.1:4789/mcp`
- Host health check: `curl http://127.0.0.1:4789/healthz`
- Executor health check: `sudo podman exec executor-selfhost bun -e 'const r=await fetch("http://10.88.0.1:4789/healthz"); console.log(r.status, await r.text())'`

Codex CLI on Shadow is connected to Executor with `http://127.0.0.1:4788/mcp`.
