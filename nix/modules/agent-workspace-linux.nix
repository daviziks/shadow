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
}
