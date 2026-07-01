{
  config,
  lib,
  pkgs,
  ...
}:
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.auto-optimise-store = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  nix.optimise.automatic = true;

  nixpkgs.config.allowUnfree = true;

  time.timeZone = "America/Cayenne";
  i18n.defaultLocale = "en_US.UTF-8";

  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  services.resolved.enable = true;
  services.fstrim.enable = true;
  zramSwap.enable = true;

  system.autoUpgrade = {
    enable = true;
    flake = "github:daviziks/shadow#shadow";
    operation = "switch";
    dates = "Sun 04:00";
    randomizedDelaySec = "2h";
    allowReboot = false;
    flags = [ "--refresh" ];
  };

  programs.fish.enable = true;
  environment.shells = [ pkgs.fish ];

  users.mutableUsers = true;
  users.users.daviziks = {
    isNormalUser = true;
    description = "Davi Oliveira";
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "render"
      "input"
      "podman"
    ];
    shell = pkgs.fish;
  };

  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = with pkgs; [
    vim
    git
    curl
    wget
    pciutils
    usbutils
    btop
    lsof
    tcpdump
  ];
}
