# Agent Workspace Linux

Shadow installs `agent-workspace-linux` as a headless MCP/runtime surface for AI-controlled browser and GUI work.

It is separate from the removed host GUI profile: it starts an isolated Xvfb workspace on demand and does not drive the real Shadow desktop.

Useful checks:

```sh
agent-workspace-linux doctor
agent-workspace-linux workspace start --dry-run
agent-workspace-linux workspace start --ack-hidden-workspace --purpose "Shadow QA"
agent-workspace-linux workspace observe --screenshot --output /tmp/agent-workspace.png
agent-workspace-linux workspace stop
```

MCP host configuration:

```json
{
  "mcpServers": {
    "agent-workspace-linux": {
      "command": "/run/current-system/sw/bin/agent-workspace-linux",
      "args": ["mcp"]
    }
  }
}
```

Use this for throwaway browser/GUI automation. Do not store corporate browser credentials on Shadow.
