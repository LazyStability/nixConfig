{
  description = "My first flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOs/nixpkgs/nixos-unstable";

    # hyprland.url = "github:hyprwm/Hyprland";
    
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xremap-flake.url = "github:xremap/nix-flake";
    wezterm-flake.url = "github:wez/wezterm?dir=nix";
  };

  outputs = {self, nixpkgs, nixpkgs-unstable, home-manager, ...}@inputs: 
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
      systemSettings = {};
      userSettings = {
	  # Either gnome or hyprland
	  wm = "gnome";
	  # Either kitty or wezterm
	  terminal = "kitty";
	};
    in{
      nixosConfigurations = {
        Kronos = lib.nixosSystem{
          inherit system;
	  modules = [./system/configuration.nix
	  	     ./system/Kronos/hardware-configuration.nix];
	  specialArgs = {
	    inherit inputs;
	    inherit pkgs-unstable;
	    inherit systemSettings;
	    inherit userSettings;
	  };
        };
        Thor = lib.nixosSystem{
          inherit system;
	  modules = [./system/configuration.nix
	  	     ./system/Thor/hardware-configuration.nix];
	  specialArgs = {
	    inherit inputs;
	    inherit pkgs-unstable;
	    inherit systemSettings;
	    inherit userSettings;
	  };
        };
     };
     homeConfigurations = {
       me = home-manager.lib.homeManagerConfiguration{
	 inherit pkgs;
	 modules = [./user/home.nix];
	 extraSpecialArgs = {
	   inherit inputs;
	   inherit pkgs-unstable;
	    inherit systemSettings;
	    inherit userSettings;
	 };
       };
     };
  };
}
