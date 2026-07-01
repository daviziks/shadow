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

  # User-facing services are reachable only through Tailscale.
  networking.firewall.interfaces."tailscale0" = {
    allowedTCPPorts = [
      22
    ];
  };
}
