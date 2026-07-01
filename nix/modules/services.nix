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
      respond "shadow task gateway ready"
    '';
  };

  services.sunshine = {
    enable = true;
    autoStart = false;
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
