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
      respond "shadow service gateway"
    '';
  };

  virtualisation.oci-containers.backend = "podman";
  virtualisation.oci-containers.containers.executor-selfhost = {
    image = "ghcr.io/rhyssullivan/executor-selfhost:latest";
    autoStart = true;
    ports = [ "4788:4788" ];
    volumes = [ "/home/daviziks/dev/.services/executor:/data" ];
    environment = {
      EXECUTOR_WEB_BASE_URL = "http://shadow:4788";
      EXECUTOR_ALLOW_LOCAL_NETWORK = "false";
    };
  };

  # User-facing services are reachable only through Tailscale.
  networking.firewall.interfaces."tailscale0" = {
    allowedTCPPorts = [
      22
      80
      4788
      7080
    ];
  };
}
