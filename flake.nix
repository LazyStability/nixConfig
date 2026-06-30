{
  description = "My first flake";

  inputs = {
    # nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs.url = "github:NixOs/nixpkgs/nixos-unstable";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    natsumi-theme = {
      url = "github:greeeen-dev/natsumi-browser";
      flake = false;
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    watt = {
      url = "github:NotAShelf/watt";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # yazi.url = "github:sxyazi/yazi";
  };
  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    let
      inherit (nixpkgs) lib;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      extraPackages = import ./packages/packages.nix { inherit (pkgs) lib callPackage; };
    in
    {
      nixosConfigurations = {
        Kronos = lib.nixosSystem {
          inherit system;
          modules = [
            ./Hosts/Kronos
          ];
          specialArgs = {
            inherit
              inputs
              extraPackages
              self
              ;
          };
        };
        Thor = lib.nixosSystem {
          inherit system;
          modules = [
            ./Hosts/Thor
          ];
          specialArgs = {
            inherit
              inputs
              self
              extraPackages
              ;
          };
        };
        Nyx = lib.nixosSystem {
          inherit system;
          modules = [
            ./Hosts/Nyx
          ];
          specialArgs = {
            inherit
              inputs
              extraPackages
              self
              ;
          };
        };
        OdinNix = lib.nixosSystem {
          inherit system;
          modules = [
            ./Hosts/Odin/configuration.nix
          ];
          specialArgs = {
            inherit
              inputs
              self
              ;
          };
        };
        Test = lib.nixosSystem {
          inherit system;
          modules = [
            ./Hosts/Test/configuration.nix
          ];
          specialArgs = {
            inherit
              inputs
              self
              extraPackages
              ;
          };
        };
      };
      devShells.${system}.default = pkgs.mkShellNoCC {
        FLAKE = ./.;
        # Allows us to work with sops in the repository
        shellHook = "";
        packages = with pkgs; [
          sops
          # Formatter
          treefmt
          nixfmt
          deadnix
          nix-init
        ];
      };
      # Is going to be deprecated
      formatter.${system} = pkgs.treefmt;
      # wrapped by treefmt-nix
      # formatter.${system} = pkgs.nixfmt-tree;
      packages.${system}.nvim = pkgs.callPackage ./packages/nvim/neovim.nix { };
      apps = rec {
        default = Test;
        Test = {
          type = "app";
          program = lib.getExe self.nixosConfigurations.Test.config.system.build.vm;
        };
      };
    };
}
