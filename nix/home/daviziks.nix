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
}
