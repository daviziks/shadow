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
    ../../modules/backup-storage.nix
    ../../modules/devtools.nix
    ../../modules/services.nix
    ../../modules/task-workspace.nix
  ];

  networking.hostName = "shadow";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];
  boot.kernelModules = [ "kvm-amd" ];
  hardware.cpu.amd.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;
  hardware.graphics.enable = true;

  services.hardware.openrgb.enable = false;

  system.stateVersion = "26.05";
}
