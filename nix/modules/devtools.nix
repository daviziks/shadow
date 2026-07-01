{
  config,
  lib,
  pkgs,
  unstable,
  ...
}:
{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  virtualisation.containers.enable = true;
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    dockerSocket.enable = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
      flags = [ "--filter=until=168h" ];
    };
    defaultNetwork.settings.dns_enabled = true;
  };

  environment.etc."containers/storage.conf".text = lib.mkDefault ''
    [storage]
    driver = "overlay"
    runroot = "/run/containers/storage"
    graphroot = "/home/daviziks/dev/.containers/storage"

    [storage.options]
    mount_program = "${pkgs.fuse-overlayfs}/bin/fuse-overlayfs"
  '';

  environment.systemPackages = [
    pkgs.age
    pkgs.ast-grep
    pkgs.bat
    pkgs.eza
    pkgs.fd
    pkgs.fuse-overlayfs
    pkgs.fzf
    pkgs.gh
    pkgs.git-lfs
    pkgs.jq
    pkgs.just
    pkgs.nixfmt
    pkgs.podman-compose
    pkgs.ripgrep
    pkgs.starship
    pkgs.yq
    unstable.bun
    unstable.nodejs_24
    unstable.go
    unstable.rustup
    unstable.uv
  ];
}
