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

  virtualisation.oci-containers.backend = "podman";
  virtualisation.oci-containers.containers.executor-selfhost = {
    image = "ghcr.io/rhyssullivan/executor-selfhost:latest";
    autoStart = true;
    ports = [ "4788:4788" ];
    volumes = [ "/home/daviziks/dev/.services/executor:/data" ];
    environment = {
      EXECUTOR_WEB_BASE_URL = "http://shadow:4788";
      EXECUTOR_ALLOW_LOCAL_NETWORK = "true";
    };
  };

  systemd.services.podman-executor-selfhost = {
    serviceConfig = {
      Restart = lib.mkForce "always";
      RestartSec = "5s";
    };
    unitConfig.StartLimitIntervalSec = 0;
  };

  # User-facing services are reachable only through Tailscale.
  networking.firewall.interfaces."tailscale0" = {
    allowedTCPPorts = [
      22
      4788
    ];
  };
}
