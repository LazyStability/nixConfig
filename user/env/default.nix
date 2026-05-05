{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
let
  pathContains =
    string: file:
    if (builtins.match (".*" + string + ".*") (lib.toString file)) != null then true else false;
  # TODO: Put in the paths contains as arguments instead of hardcoding and do the same with permissions
  # Also create directories with similar permissions
  recurseIntoDir =
    target_path: source_dir:
    builtins.listToAttrs (
      map
        (
          x:
          let
            target = target_path + (lib.removePrefix (toString source_dir) (toString x));
            executable = (lib.hasSuffix ".sh" (toString x));
            permissions =
              if (pathContains "gnupg" (toString x)) then
                "400"
              else if (pathContains "vesktop" (toString x)) then
                "660"
              else
                # Readonly
                "400";
          in
          {
            name = target;
            value = {
              type = "copy";
              source = x;
              inherit target executable permissions;
            };
          }
        )
        (
          lib.lists.filter (
            file:
            !(pathContains "hypr" file) && !(pathContains "swaync" file) && !(pathContains "systemd/user" file)
          ) (lib.filesystem.listFilesRecursive source_dir)
        )
    );

in
{
  hjem.users.me = {
    # Additional files from the nix store the rest is copied with recurseIntoDir
    xdg.data.files = {
      "icons/Bibata".source = "${pkgs.bibata-cursors.outPath}/share/icons/Bibata-Modern-Ice";
      "icons/Adwaita".source = "${pkgs.adwaita-icon-theme}/share/icons/Adwaita";

    };
    # Firefox
    files =
      let
        hyprland-window-quickswitcher =
          pkgs.callPackage ../scripts/desktop-utils/hyprland-window-quickswitcher.nix
            { };
        hyprland-move-workpace-to-monitor =
          pkgs.callPackage ../scripts/desktop-utils/hyprland-move-workpace-to-monitor.nix
            { };
        hyprland-binds = pkgs.callPackage ../scripts/desktop-utils/hyprland-binds.nix { };
        hyprland-switch-behaviour =
          pkgs.callPackage ../scripts/desktop-utils/hyprland-switch-behaviour.nix
            { config = config; };
        vim-anywhere = pkgs.callPackage ../scripts/desktop-utils/vim-anywhere.nix { };
        quickcapture = pkgs.callPackage ../scripts/desktop-utils/quickcapture.nix { };
        swaync-soundscript = pkgs.callPackage ../scripts/desktop-utils/swaync-soundscript.nix { };

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
            hyprland-switch-behaviour
            hyprland-binds
            hyprland-window-quickswitcher
            hyprland-switch-behaviour
            hyprland-move-workpace-to-monitor
            quickcapture
            vim-anywhere

          ];
        };
        ".config/gnupg" = {
          type = "directory";
          permissions = "700";
        };
        ".config/swaync".source = directorySub {
          runCommand = pkgs.runCommand;
          coreutils = pkgs.coreutils;
          folder = ./config/swaync;
          packages = [
            swaync-soundscript
          ];
        };
      }
      // (recurseIntoDir ".mozilla" ./mozilla)
      // (recurseIntoDir ".config" ./config)
      // (recurseIntoDir ".local" ./local)
      // (recurseIntoDir ".ssh" ./ssh);
  };
}
