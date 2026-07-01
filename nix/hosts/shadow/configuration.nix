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
    ../../modules/agent-workspace-linux.nix
    ../../modules/codex.nix
    ../../modules/devtools.nix
    ../../modules/herdr.nix
    ../../modules/services.nix
    ../../modules/shadow-ws.nix
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
  services.hardware.openrgb.enable = false;

  system.stateVersion = "26.05";
}
