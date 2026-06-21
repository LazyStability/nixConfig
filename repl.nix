# Credit: https://iampavel.dev/blog/how-to-read-nix-error#the-anatomy-of-a-nix-error
{
  # Pass your host name when starting the repl
  host ? "Kronos",
  ...
}:
let
  flake = builtins.getFlake (toString ./.);
  inherit (flake.inputs.nixpkgs) lib;
in
rec {
  inherit lib;
  inherit (flake) inputs;

  # Quick access to current host
  c = flake.nixosConfigurations.${host}.config;
  config = c;
  co = c.custom;
  pkgs = flake.nixosConfigurations.${host}.pkgs;

  # Helper functions for debugging
  keys = lib.attrNames; # List all attributes in a set
  deps = pkg: map (p: p.name or "unknown") (pkg.buildInputs ++ pkg.nativeBuildInputs or [ ]);

  # Find where an option is defined (filters out nixos internals)
  where =
    path:
    let
      opt = lib.attrByPath (lib.splitString "." path) null flake.nixosConfigurations.${host}.options;
      decls = if opt != null && opt ? files then opt.files else [ ];
      isMine = f: !(lib.hasInfix "system" (toString f));
    in
    lib.filter isMine decls;

  # Reload without exiting repl
  reload = import ./repl.nix { inherit host; };
}
// flake.nixosConfigurations # Merge in all host configs
