{
  writeShellApplication,
  gnupg,
  ...
}:
writeShellApplication {
  name = "gpg-setup";
  runtimeInputs = [
    gnupg
  ];
  text =
    let
      gpg = "${gnupg}/bin/gpg";
      key = ./public-key.asc;
      trust = "5";
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
      gpg --import ${key}

      importTrust ${key} ${trust}
    '';

}
