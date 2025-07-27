{
  lib,
  config,
  pkgs,
  ...
}:
{

  # Entry for home manager configuration
  home.file = lib.mkIf config.programs.sioyek.enable {
    ".config/sioyek/keys_user.config".source = ./sioyek_keys.config;
  };
  programs.sioyek = {
    enable = lib.mkDefault true;
    # The package can also just be added to systemPackages
    package = pkgs.symlinkJoin {
      name = "sioyek";
      paths = [ pkgs.sioyek ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/sioyek \
          --set QT_QPA_PLATFORM xcb
      '';
    };
  };
}
