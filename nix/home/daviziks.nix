{
  config,
  pkgs,
  unstable,
  ...
}:
{
  home.stateVersion = "26.05";

  home.username = "daviziks";
  home.homeDirectory = "/home/daviziks";

  programs.home-manager.enable = true;

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -g fish_greeting ""
    '';
    shellAliases = {
      ll = "eza -lah --git";
      gs = "git status --short";
      dev = "cd /home/daviziks/dev";
    };
  };

  programs.starship.enable = true;

  programs.git = {
    enable = true;
    settings = {
      user.name = "davi oliveira";
      user.email = "davioliveira.java@gmail.com";
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      rerere.enabled = true;
    };
  };

  programs.gh.enable = true;

  xdg.configFile."ghostty/config".text = ''
    theme = dark:Adwaita Dark,light:Adwaita
    font-size = 11
  '';

  xdg.configFile."kwalletrc".text = ''
    [Wallet]
    Enabled=true
    First Use=false
    Default Wallet=kdewallet

    [org.freedesktop.secrets]
    apiEnabled=true
  '';

  xdg.configFile."kdeglobals".text = ''
    [General]
    ColorScheme=BreezeDark
    Name=Breeze Dark
    fixed=JetBrainsMono Nerd Font,10,-1,5,50,0,0,0,0,0
    font=SF Pro Text,10,-1,5,50,0,0,0,0,0
    menuFont=SF Pro Text,10,-1,5,50,0,0,0,0,0
    smallestReadableFont=SF Pro Text,8,-1,5,50,0,0,0,0,0
    toolBarFont=SF Pro Text,10,-1,5,50,0,0,0,0,0

    [Icons]
    Theme=Papirus

    [WM]
    activeFont=SF Pro Text,10,-1,5,57,0,0,0,0,0
  '';

  xdg.configFile."kscreenlockerrc".text = ''
    [Daemon]
    Autolock=false
    LockOnResume=false
    Timeout=0
  '';

  xdg.configFile."powermanagementprofilesrc".text = ''
    [AC]
    icon=battery-charging

    [AC][BrightnessControl]
    value=100

    [AC][DimDisplay]
    idleTime=0

    [AC][SuspendSession]
    idleTime=0
    suspendThenHibernate=false
    suspendType=0

    [Battery]
    icon=battery-060

    [Battery][BrightnessControl]
    value=100

    [Battery][DimDisplay]
    idleTime=0

    [Battery][SuspendSession]
    idleTime=0
    suspendThenHibernate=false
    suspendType=0

    [LowBattery]
    icon=battery-low

    [LowBattery][BrightnessControl]
    value=100

    [LowBattery][DimDisplay]
    idleTime=0

    [LowBattery][SuspendSession]
    idleTime=0
    suspendThenHibernate=false
    suspendType=0
  '';

  xdg.configFile."kcminputrc".text = ''
    [Mouse]
    cursorTheme=breeze_cursors
  '';

  home.packages = [
    unstable.google-chrome
    unstable.vscode
    unstable.ghostty
  ];
}
