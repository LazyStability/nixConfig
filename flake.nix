{
  description = "My first flake";

  inputs = {
    # nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs.url = "github:NixOs/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    systems.url = "github:nix-systems/default";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
      inputs.flake-utils.follows = "flake-utils";
      inputs.systems.follows = "systems";
    };
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
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
    # yazi.url = "github:sxyazi/yazi";
  };
  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
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
              self
              ;
          };
        };
      };
      homeConfigurations = {
        me = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./user/home.nix ];
          extraSpecialArgs = {
            inherit
              inputs
              ;
          };
        };
      };
      devShells.${system}.default = pkgs.mkShellNoCC {
        FLAKE = ./.;
        # Allows us to work with sops in the repository
        shellHook = ''
          export SOPS_AGE_KEY=$(printf "url=https://example.com" | git-credential-keepassxc get | sed -n 's/^password=//1p')
        '';
        packages = with pkgs; [
          sops
          (git-credential-keepassxc.override { withNotification = true; })
          # Formatter
          treefmt
          nixfmt-rfc-style
          deadnix
        ];
      };
      # Is going to be deprecated
      formatter.${system} = pkgs.treefmt;
      # wrapped by treefmt-nix
      # formatter.${system} = pkgs.nixfmt-tree;
    };
}
