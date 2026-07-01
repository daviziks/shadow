{
  config,
  lib,
  pkgs,
  unstable,
  ...
}:
{
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.autoLogin = {
    enable = true;
    user = "daviziks";
  };
  services.desktopManager.plasma6.enable = true;

  # Remote usability matters more than at-rest local secrecy on this machine.
  security.pam.services.kwallet.enableKwallet = false;

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa
    kate
    khelpcenter
    okular
  ];

  environment.systemPackages = [
    unstable.google-chrome
    unstable.vscode
    unstable.ghostty
    pkgs.papirus-icon-theme
  ];
}
