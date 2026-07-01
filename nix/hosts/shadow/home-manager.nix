{ unstable, ... }:
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "hm-backup";
  home-manager.extraSpecialArgs = { inherit unstable; };
  home-manager.users.daviziks = import ../../home/daviziks.nix;
}
