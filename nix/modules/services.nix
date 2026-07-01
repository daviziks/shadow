{
  config,
  lib,
  pkgs,
  unstable,
  ...
}:
{
  services.tailscale = {
    enable = true;
    package = unstable.tailscale;
    useRoutingFeatures = "client";
  };

  # Tailscale login is intentionally manual after install:
  #   sudo tailscale up --ssh
  services.openssh = {
    enable = true;
    openFirewall = false;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  services.caddy = {
    enable = true;
    package = unstable.caddy;
    globalConfig = ''
      auto_https off
    '';
    virtualHosts."http://shadow".extraConfig = ''
      redir /shadow/executor /shadow/executor/
      handle_path /shadow/executor/* {
        reverse_proxy 127.0.0.1:4788
      }
      respond "shadow service gateway"
    '';
  };

  virtualisation.oci-containers.backend = "podman";
  virtualisation.oci-containers.containers.executor-selfhost = {
    image = "ghcr.io/rhyssullivan/executor-selfhost:latest";
    autoStart = true;
    ports = [ "127.0.0.1:4788:4788" ];
    volumes = [ "/home/daviziks/dev/.services/executor:/data" ];
    environment = {
      EXECUTOR_WEB_BASE_URL = "http://shadow/shadow/executor";
      EXECUTOR_ALLOW_LOCAL_NETWORK = "false";
    };
  };

  services.sunshine = {
    enable = true;
    autoStart = true;
    openFirewall = false;
    capSysAdmin = true;
  };

  # User-facing services are reachable only through Tailscale.
  # Sunshine default ports are documented by LizardByte as offsets from port 47989.
  networking.firewall.interfaces."tailscale0" = {
    allowedTCPPorts = [
      22
      80
      47984
      47989
      47990
      48010
    ];
    allowedUDPPorts = [
      47998
      47999
      48000
      48002
      48010
    ];
  };

  services.avahi.enable = true;
  services.printing.enable = true;
}
