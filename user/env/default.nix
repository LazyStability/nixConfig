{
  pkgs,
  inputs,
  lib,
  ...
}:
{
  hjem.users.me = {
    xdg.data.files = {
      "icons/Bibata".source = "${pkgs.bibata-cursors.outPath}/share/icons/Bibata-Modern-Ice";
      "icons/Adwaita".source = "${pkgs.adwaita-icon-theme}/share/icons/Adwaita";
      "icons/default/index.theme".source = ./local/share/icons/default/index.theme;
      "wallpaper".source = ./local/share/wallpaper;
    };
    # Firefox
    files =
      let
        recurseIntoDir =
          target_path: source_dir:
          builtins.listToAttrs (
            map (
              x:
              let
                target = target_path + (lib.removePrefix (toString source_dir) (toString x));
                executable = (lib.hasSuffix ".sh" (toString x));
              in
              {
                name = target;
                value = {
                  type = "copy";
                  source = x;
                  inherit target executable;
                };
              }
            ) (lib.filesystem.listFilesRecursive source_dir)
          );
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
        # Firefox
        ".mozilla/firefox/me/chrome/natsumi".source = inputs.natsumi-theme + "/natsumi";
        ".mozilla/firefox/me/chrome/natsumi-config.css".source =
          inputs.natsumi-theme + "/natsumi-config.css";
        ".mozilla/firefox/me/user.js".text =
          (builtins.readFile "${pkgs.arkenfox-userjs}/user.js")
          + (builtins.readFile ./mozilla/firefox/me/user-overrides.js);

        ".zshrc".source = ./zshrc;
        ".zshenv".source = ./zshenv;
        # Theming
        ".icons/Bibata".source = "${pkgs.bibata-cursors.outPath}/share/icons/Bibata-Modern-Ice";
        ".icons/Adwaita".source = "${pkgs.adwaita-icon-theme}/share/icons/Adwaita";
        ".icons/default/index.theme".source = ./local/share/icons/default/index.theme;
        ".Xresources".source = ./Xresources;
        ".gtkrc-2.0".source = ./gtkrc-2.0;
        ".themes/adw-gtk3".source = "${pkgs.adw-gtk3.outPath}/share/themes/adw-gtk3";

        ".config/hypr".source = directorySub {
          runCommand = pkgs.runCommand;
          coreutils = pkgs.coreutils;
          folder = ./config/hypr;
          packages = [
            hyprland-windowswitcher
            hyprland-binds
            # hypr-lid-switch
            hyprland-move-workspace-to-monitor
          ];

        };
      }
      // (recurseIntoDir ".mozilla" ./mozilla)
      // (recurseIntoDir ".config" ./config)
      // (recurseIntoDir ".ssh" ./ssh);
  };
}
