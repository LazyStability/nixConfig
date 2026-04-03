{ pkgs, ... }:
{
  hjem.users.me = {
    environment.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      XCURSOR_SIZE = 24;
      XCURSOR_THEME = "Bibata-Modern-Ice";
      HYPRCURSOR_THEME = "Bibata-Modern-Ice";
      HYPRCURSOR_SIZE = 24;
    };
    xdg.data.files = {
      "icons/Bibata".source = "${pkgs.bibata-cursors.outPath}/share/icons/Bibata-Modern-Ice";
      "icons/Adwaita".source = "${pkgs.adwaita-icon-theme}/share/icons/Adwaita";
      "icons/default/index.theme".source = ./local/share/icons/default/index.theme;
      "wallpaper".source = ./local/share/wallpaper;
    };
    files = {
      ".icons/Bibata".source = "${pkgs.bibata-cursors.outPath}/share/icons/Bibata-Modern-Ice";
      ".icons/Adwaita".source = "${pkgs.adwaita-icon-theme}/share/icons/Adwaita";
      ".icons/default/index.theme".source = ./local/share/icons/default/index.theme;
      ".Xresources".source = ./Xresources;
      ".gtkrc-2.0".source = ./gtkrc-2.0;
      ".themes/adw-gtk3".source = "${pkgs.adw-gtk3.outPath}/share/themes/adw-gtk3";
      ".config/hypr".source =
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
        directorySub {
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
    };
  };
}
