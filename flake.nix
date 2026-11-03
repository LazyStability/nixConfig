{
  description = "My first flake";

  inputs = {
    # nixpkgs-stable.url = "https://channels.nixos.org/nixos-26.05/nixexprs.tar.xz";
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";

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
    # jail-nix.url = "sourcehut:~alexdavid/jail.nix";
    jail-nix.url = "git+ssh://git@codeberg.org/LazilyStableProton/jail.nix.git?ref=beta&shallow=1";
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
      jail = inputs.jail-nix.lib.init pkgs;
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
              jail
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
              jail
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
              jail
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
              jail
              extraPackages
              ;
          };
        };
      };
      devShells.${system}.default = pkgs.mkShellNoCC {
        FLAKE = ./.;
        # Allows us to work with sops in the repository
        shellHook = ''
          unset PYTHONPATH
        '';
        env = {
          UV_PYTHON_DOWNLOADS = "never";
          UV_PYTHON = pkgs.python312.interpreter;
          LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath pkgs.pythonManylinuxPackages.manylinux1;
        };
        packages = with pkgs; [
          sops
          # Formatter
          treefmt
          nixfmt
          deadnix
          # For ai
          python312
          nodejs_26
          uv
          ty
          fd
          ripgrep

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
