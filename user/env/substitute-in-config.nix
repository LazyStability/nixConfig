{ pkgs, ... }:
let
  hyprland-windowswitcher = pkgs.callPackage ../scripts/window-quickswitcher.nix { };
  hyprland-move-workspace-to-monitor = pkgs.callPackage ../scripts/move-workpace-to-monitor.nix { };
  hyprland-binds = pkgs.callPackage ../scripts/hypr-binds.nix { };
  # hypr-lid-switch = pkgs.callPackage ../scripts/hyprland-switch-behaviour.nix { };

  directorySub =
    {
      runCommand,
      coreutils,
      folder,
      packages,
    }:
    let
      thrower = pkgs.lib.throwIf (pkgs.lib.typeOf packages != "list");
      substituteString = pkgs.lib.strings.concatMapStrings (
        package: " -e 's,/usr/bin/${package.meta.mainProgram},${pkgs.lib.getExe package},g'"
      ) packages;
    in
    runCommand "replace"
      {
        nativeBuildInputs = [ coreutils ];
      }
      ''
        mkdir -p $out

        echo "${substituteString}"
        for file in ${folder}/*; do
         sed -r ${substituteString} "$file" > $out/$(${pkgs.coreutils}/bin/basename "$file")


        done
      '';
in
{
  hjem.user.me.files.".config/hypr".source = directorySub {
    runCommand = pkgs.runCommand;
    coreutils = pkgs.coreutils;
    folder = ./env/config/hypr;
    packages = [
      hyprland-windowswitcher
      hyprland-binds
      # hypr-lid-switch
      hyprland-move-workspace-to-monitor
    ];

  };
}
