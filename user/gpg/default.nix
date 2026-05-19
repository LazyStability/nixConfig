{ pkgs, lib, ... }:
let
  importTrustBashFunctions =
    let
      gpg = "${pkgs}/bin/gpg";
    in
    ''
      function gpgKeyId() {
        ${gpg} --show-key --with-colons "$1" \
          | grep ^pub: \
          | cut -d: -f5
      }

      function importTrust() {
        local keyIds trust
        mapfile -t keyIds <<< "$(gpgKeyId "$1")"
        trust="$2"
        for id in "''${keyIds[@]}" ; do
          { echo trust; echo "$trust"; (( trust == 5 )) && echo y; echo quit; } \
            | ${gpg} --no-tty --command-fd 0 --edit-key "$id"
        done
      }

    '';

  keyringFiles =
    let
      gpg = "${pkgs}/bin/gpg";

      importKey =
        { source, trust, ... }:
        ''
          ${gpg} --import ${source}
          ${lib.optionalString (trust != null) ''importTrust "${source}" ${toString trust}''}
        '';

      importKeys = lib.concatMapStringsSep "\n" importKey ./public-key.asc;
    in
    pkgs.runCommand "gpg-pubring" { buildInputs = [ pkgs.gpg ]; } ''
      export GNUPGHOME
      GNUPGHOME=$(mktemp -d)

      ${importTrustBashFunctions}
      ${importKeys}

      mkdir $out
      cp $GNUPGHOME/pubring.kbx $out/pubring.kbx
      if [[ -e $GNUPGHOME/trustdb.gpg ]] ; then
        cp $GNUPGHOME/trustdb.gpg $out/trustdb.gpg
      fi
    '';
in
{
  hjem.users.me.xdg.data.files = {
    "gnupg/pubring.kbx" = {
      source = "${keyringFiles}/pubring.kbx";
      type = "copy";
    };
    "gnupg/trustdb.gpg" = {
      source = "${keyringFiles}/trustdb.gpg";
      type = "copy";
    };
  };
}
