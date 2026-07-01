{ pkgs, ... }:
let
  agentWorkspaceLinux = pkgs.stdenv.mkDerivation {
    pname = "agent-workspace-linux";
    version = "0.2.0";

    src = pkgs.fetchurl {
      url = "https://github.com/agent-sh/agent-workspace-linux/releases/download/v0.2.0/agent-workspace-linux-x86_64-unknown-linux-gnu";
      hash = "sha256-A/VqLIm0+Luqr2nGVAv77VOBBmI7s4p6KfmhNtqU5j0=";
    };

    dontUnpack = true;

    nativeBuildInputs = [ pkgs.autoPatchelfHook ];

    buildInputs = [
      pkgs.stdenv.cc.cc.lib
      pkgs.glibc
      pkgs.libxcb
      pkgs.libxkbcommon
    ];

    installPhase = ''
      install -Dm755 "$src" "$out/bin/agent-workspace-linux"
    '';
  };
in
{
  environment.systemPackages = [
    agentWorkspaceLinux
    pkgs.bubblewrap
    pkgs.chromium
    pkgs.imagemagick
    pkgs.libxkbcommon
    pkgs.openbox
    pkgs.pkg-config
    pkgs.xclip
    pkgs.xdotool
    pkgs.xterm
    pkgs.xauth
    pkgs.xdpyinfo
    pkgs.xhost
    pkgs.xprop
    pkgs.xvfb
    pkgs.xwininfo
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
      pkgs.nodejs_24
      agentWorkspaceLinux
    ];
    serviceConfig = {
      User = "daviziks";
      Group = "users";
      WorkingDirectory = "/home/daviziks/dev";
      Restart = "always";
      RestartSec = "5s";
      ExecStart = pkgs.writeShellScript "agent-workspace-linux-mcp-start" ''
        ${pkgs.nodejs_24}/bin/npx -y supergateway@3.4.3 \
          --stdio "${agentWorkspaceLinux}/bin/agent-workspace-linux mcp --headless" \
          --outputTransport streamableHttp \
          --streamableHttpPath /mcp \
          --port 4789 \
          --baseUrl http://10.88.0.1:4789 \
          --healthEndpoint /healthz \
          --logLevel info
      '';
    };
    unitConfig.StartLimitIntervalSec = 0;
  };

  networking.firewall.interfaces."podman0".allowedTCPPorts = [ 4789 ];
}
