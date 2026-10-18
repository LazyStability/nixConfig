{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";

  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    let
    in
    {
      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        # FIXME replace with your hostname
        Kronos = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          # > Our main nixos configuration file <
          modules = [ ./nixos/configuration.nix ];
        };
      };

    };
}
