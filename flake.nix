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
    nebula-theme = {
      url = "github:JustAdumbPrsn/Nebula-A-Minimal-Theme-for-Zen-Browser";
      flake = false;
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
      systemSettings = { };
      userSettings = {
        # Either gnome, KDE or hyprland
        wm = "hyprland";
        # Either kitty or wezterm
        terminal = "kitty";
      };
    in
    {
      nixosConfigurations = {
        Kronos = lib.nixosSystem {
          inherit system;
          modules = [
            ./Hosts/Kronos
          ];
          specialArgs = {
            inherit inputs;
            inherit systemSettings;
            inherit userSettings;
            inherit self;
          };
        };
        Thor = lib.nixosSystem {
          inherit system;
          modules = [
            ./Hosts/Thor
          ];
          specialArgs = {
            inherit inputs;
            inherit systemSettings;
            inherit userSettings;
            inherit self;
          };
        };
      };
      homeConfigurations = {
        me = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./user/home.nix ];
          extraSpecialArgs = {
            inherit inputs;
            inherit systemSettings;
            inherit userSettings;
          };
        };
      };
      # Is going to be deprecated
      formatter.${system} = pkgs.nixfmt-rfc-style;
      # wrapped by treefmt-nix
      # formatter.${system} = pkgs.nixfmt-tree;
    };
}
