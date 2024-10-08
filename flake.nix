{
  description = "My first flake";

  inputs = {
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs.url = "github:NixOs/nixpkgs/nixos-unstable";

    # hyprland.url = "github:hyprwm/Hyprland";
    
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xremap-flake.url = "github:xremap/nix-flake";
    wezterm-flake.url = "github:wez/wezterm?dir=nix";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {self, nixpkgs, nixpkgs-stable, home-manager, ...}@inputs: 
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      pkgs-stable = nixpkgs-stable.legacyPackages.${system};
      systemSettings = {};
      userSettings = {
	  # Either gnome or hyprland
	  wm = "hyprland";
	  # Either kitty or wezterm
	  terminal = "kitty";
	};
    in{
      nixosConfigurations = {
        Kronos = lib.nixosSystem{
          inherit system;
	  modules = [
		    (import ./system/Kronos/disko.nix {device = "/dev/disk/by-id/wwn-0x5002538043584d30"; inherit inputs;})
		    ./system/configuration.nix
	  	    ./system/Kronos/hardware-configuration.nix
	  ];
	  specialArgs = {
	    inherit inputs;
	    inherit pkgs-stable;
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
	    inherit pkgs-stable;
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
	   inherit pkgs-stable;
	    inherit systemSettings;
	    inherit userSettings;
	 };
       };
     };
  };
}
