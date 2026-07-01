{ pkgs, unstable, ... }:
{
  systemd.tmpfiles.rules = [
    "d /home/daviziks/dev/workspaces 0755 daviziks users -"
    "d /home/daviziks/dev/.services/agent-workspace-linux-mcp 0755 daviziks users -"
  ];

  environment.systemPackages = [
    (pkgs.writeShellScriptBin "shadow-ws" (builtins.readFile ../../scripts/shadow-ws))
  ];

  systemd.services.agent-workspace-linux-mcp = {
    description = "Agent Workspace Linux MCP Streamable HTTP bridge";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    environment = {
      HOME = "/home/daviziks";
      npm_config_cache = "/home/daviziks/dev/.cache/pkg/npm";
    };
    path = [
      pkgs.coreutils
      pkgs.bash
      pkgs.chromium
      pkgs.openbox
      pkgs.xvfb
      pkgs.xauth
      pkgs.xdpyinfo
      pkgs.xdotool
      pkgs.xprop
      pkgs.xclip
      pkgs.imagemagick
      unstable.nodejs_24
    ];
    serviceConfig = {
      User = "daviziks";
      Group = "users";
      WorkingDirectory = "/home/daviziks/dev/.services/agent-workspace-linux-mcp";
      Restart = "on-failure";
      RestartSec = "10s";
      ExecStart = pkgs.writeShellScript "agent-workspace-linux-mcp-start" ''
        ${unstable.nodejs_24}/bin/npx -y supergateway@3.4.3 \
          --stdio "/run/current-system/sw/bin/agent-workspace-linux mcp --headless" \
          --outputTransport streamableHttp \
          --streamableHttpPath /mcp \
          --port 4789 \
          --baseUrl http://10.88.0.1:4789 \
          --healthEndpoint /healthz \
          --logLevel info
      '';
    };
  };

  networking.firewall.interfaces."podman0".allowedTCPPorts = [ 4789 ];
}
