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
  };

  outputs = {self, nixpkgs, nixpkgs-unstable, home-manager, ...}@inputs: 
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
      hosteName = "Thor";
    in{
      nixosConfigurations = {
        system = lib.nixosSystem{
          inherit system;
	  modules = [(./. + "/system" + ("/" + hosteName) + "/configuration.nix")];
	  specialArgs = {
	    inherit inputs;
	    inherit pkgs-unstable;
	    inherit hosteName;
	  };
        };
     };
     homeConfigurations = {
       user = home-manager.lib.homeManagerConfiguration{
	 inherit pkgs;
	 modules = [./home.nix];
	 extraSpecialArgs = {
	   inherit inputs;
	   inherit pkgs-unstable;
	 };
       };
     };
  };
}
