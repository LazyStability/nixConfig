{
  lib,
  pkgs,
  jail,
  ...
}:
let
  firefox = jail "firefox" pkgs.firefox (
    with jail.combinators;
    [
      gui
      gpu
      network
      camera
      (readonly "/etc/machine-id")
      (readonly "/etc/firefox/policies/policies.json")

      # Access to the keepassxc socket, we bind the parent directory of the socket, so it also works when the socket isn't created yet.
      (readwrite (noescape "\"$XDG_RUNTIME_DIR/app/org.keepassxc.KeePassXC\""))
      (fwd-env "XDG_RUNTIME_DIR")
      # Allows keepassxc-proxy libraries, so it can start, also create the socket dir for keepassxc
      (add-runtime ''
        mkdir -p "$XDG_RUNTIME_DIR/app/org.keepassxc.KeePassXC"
        while read -r P; do
          RUNTIME_ARGS+=(--ro-bind "$P" "$P")
        done < "${pkgs.writeClosure "${pkgs.keepassxc.outPath}/bin/keepassxc-proxy"}"

      '')

      (rw-bind (noescape "\"$HOME/.mozilla\"") (noescape "\"$HOME/.mozilla\""))
      (readwrite "/home/me/.cache/mozilla")
      (readwrite (noescape "\"$XDG_RUNTIME_DIR/doc/by-app/\""))
      (readwrite (noescape "\"$HOME/Downloads\""))

      # Yubikey
      fido-token

      (dbus {
        own = [
          "org.mozilla.firefox.*"
          "org.mpris.MediaPlayer2.firefox.*"
        ];
        talk = [
          "ca.desrt.dconf"
          "org.a11y.Bus"
          "org.freedesktop.DBus"
          "org.freedesktop.portal.*"
          "org.freedesktop.FileChooser"
          "org.gtk.vfs"
          "org.gtk.vfs.*"
        ];
      })
    ]
  );

in
{
  programs = {
    firefox = lib.mkMerge [
      {
        package = firefox;
      }
      (import ./firefox-wrapping.nix { inherit pkgs lib; })
    ];
  };
}
