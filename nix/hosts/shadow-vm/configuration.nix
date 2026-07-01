{
  config,
  lib,
  pkgs,
  unstable,
  ...
}:
{
  imports = [
    ../../modules/base.nix
    ../../modules/devtools.nix
    ../../modules/task-workspace.nix
  ];

  networking.hostName = "shadow-vm";

  boot.loader.grub.devices = [ "nodev" ];
  fileSystems."/" = {
    device = "tmpfs";
    fsType = "tmpfs";
  };

  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;

  services.getty.autologinUser = "daviziks";

  virtualisation.vmVariant = {
    virtualisation.memorySize = 4096;
    virtualisation.cores = 4;
    virtualisation.forwardPorts = [
      {
        from = "host";
        host.port = 2222;
        guest.port = 22;
      }
    ];
  };

  system.stateVersion = "26.05";
}
