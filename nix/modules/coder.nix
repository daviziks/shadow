{ pkgs, ... }:
{
  services.coder = {
    enable = true;
    listenAddress = "0.0.0.0:7080";
    accessUrl = "http://shadow:7080";
    environment.extra = {
      CODER_TELEMETRY_ENABLE = "false";
      CODER_UPDATE_CHECK = "false";
    };
  };

  users.users.coder.extraGroups = [ "podman" ];

  systemd.tmpfiles.rules = [
    "d /home/daviziks/dev/.services/coder 0755 daviziks users -"
    "d /home/daviziks/dev/.services/coder/templates 0755 daviziks users -"
  ];

  environment.systemPackages = [
    pkgs.coder
    pkgs.terraform
  ];
}
