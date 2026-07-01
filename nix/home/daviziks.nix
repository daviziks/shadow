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
      user.name = "Davi Oliveira";
      init.defaultBranch = "main";
      pull.rebase = true;
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

  home.packages = [
    unstable.google-chrome
    unstable.vscode
    unstable.ghostty
  ];
}
