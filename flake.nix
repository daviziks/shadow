{
  description = "Declarative NixOS configuration for shadow";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      disko,
      ...
    }:
    let
      system = "x86_64-linux";
      unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
      specialArgs = { inherit inputs unstable; };
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations.shadow = nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules = [
          disko.nixosModules.disko
          ./nix/hosts/shadow/configuration.nix
          ./nix/hosts/shadow/disko.nix
          home-manager.nixosModules.home-manager
          ./nix/hosts/shadow/home-manager.nix
        ];
      };

      nixosConfigurations.shadow-vm = nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules = [
          ./nix/hosts/shadow-vm/configuration.nix
          home-manager.nixosModules.home-manager
          ./nix/hosts/shadow/home-manager.nix
        ];
      };

      packages.${system}.shadow-vm = self.nixosConfigurations.shadow-vm.config.system.build.vm;

      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          git
          gh
          jq
          just
          fzf
          ripgrep
          nixfmt
        ];
      };

      formatter.${system} = pkgs.writeShellApplication {
        name = "shadow-fmt";
        runtimeInputs = with pkgs; [
          findutils
          nixfmt
        ];
        text = ''
          find . -path ./.git -prune -o -name '*.nix' -print0 | xargs -0 nixfmt
        '';
      };
    };
}
