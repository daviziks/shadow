{
  config,
  lib,
  pkgs,
  unstable,
  ...
}:
let
  appleSfPro = pkgs.stdenvNoCC.mkDerivation {
    pname = "apple-sf-pro-fonts";
    version = "2026-06-08";

    src = pkgs.fetchurl {
      url = "https://devimages-cdn.apple.com/design/resources/download/SF-Pro.dmg";
      hash = "sha256-YxGk8IQ6TS5hagsFx3US0x0uqVBFnPUmzbW5CZageU8=";
    };

    nativeBuildInputs = [
      pkgs.cpio
      pkgs.p7zip
    ];

    unpackPhase = ''
      runHook preUnpack
      7z x "$src" >/dev/null
      7z x "SFProFonts/SF Pro Fonts.pkg" >/dev/null
      mkdir payload
      (cd payload && cpio -id --quiet < ../Payload~)
      runHook postUnpack
    '';

    installPhase = ''
      runHook preInstall
      install -Dm644 payload/Library/Fonts/*.otf -t $out/share/fonts/opentype
      install -Dm644 payload/Library/Fonts/*.ttf -t $out/share/fonts/truetype
      runHook postInstall
    '';

    meta = {
      description = "Apple SF Pro fonts from Apple's public design resources";
      homepage = "https://developer.apple.com/fonts/";
      license = lib.licenses.unfree;
      platforms = lib.platforms.all;
    };
  };
in
{
  services.xserver.enable = true;
  services.xserver.excludePackages = [ pkgs.xterm ];
  services.displayManager.sddm.enable = true;
  services.displayManager.autoLogin = {
    enable = true;
    user = "daviziks";
  };
  services.desktopManager.plasma6.enable = true;

  security.pam.services.kwallet.enableKwallet = true;

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  services.power-profiles-daemon.enable = true;
  systemd.services.shadow-power-profile-performance = {
    description = "Set default power profile to performance";
    wantedBy = [ "multi-user.target" ];
    after = [ "power-profiles-daemon.service" ];
    requires = [ "power-profiles-daemon.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.power-profiles-daemon}/bin/powerprofilesctl set performance";
    };
  };

  services.logind.settings.Login = {
    IdleAction = "ignore";
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitchDocked = "ignore";
    HandleSuspendKey = "ignore";
    HandleHibernateKey = "ignore";
  };

  systemd.sleep.settings.Sleep = {
    AllowSuspend = "no";
    AllowHibernation = "no";
    AllowHybridSleep = "no";
    AllowSuspendThenHibernate = "no";
  };

  fonts.packages = [
    appleSfPro
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.papirus-icon-theme
  ];
  fonts.fontconfig.defaultFonts = {
    sansSerif = [ "SF Pro Text" ];
    serif = [ "SF Pro Text" ];
    monospace = [ "JetBrainsMono Nerd Font" ];
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
