{ inputs, pkgs, ... }:
{
  environment.systemPackages = [
    inputs.herdr.packages.${pkgs.system}.herdr
  ];
}
