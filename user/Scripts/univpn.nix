{
  writeShellApplication,
  openconnect,
  wireguard-tools,
  entryname,
  database,
  User,
  Host,
  Useragent,
  vpnname,
}:
writeShellApplication {
  name = "${vpnname}vpn";
  runtimeInputs = [openconnect wireguard-tools];
  text = ''
    # Check whether the file exists
    if [ ! -f ${database} ]; then
      echo "File ${database} does not exist."
      exit 1
    elif ! [ "$(id -u)" = 0 ]; then
      echo "The script need to be run as root." >&2
      exit 1
    fi

    if [ "$1" == "up" ]; then
      # Keepassxc-cli
      echo "Enter Database Password:"
      read -rs DATABASEPASSWORD
      if ! PASSWORD=$(echo "$DATABASEPASSWORD" | keepassxc-cli show --quiet -sa password ${database} ${entryname}); then
        echo "Cant read password entry"
        DATABASEPASSWORD=""
        exit 1
      fi
      if ! TOTP=$(echo "$DATABASEPASSWORD" | keepassxc-cli show --quiet -st ${database} ${entryname}); then
        echo "Cant read password entry"
        DATABASEPASSWORD=""
        exit 1
      fi
      DATABASEPASSWORD=""

      echo "$PASSWORD" | ${openconnect}/bin/openconnect --useragent="${Useragent}" --protocol=anyconnect "${Host}" --user="${User}" --passwd-on-stdin --form-entry challenge:answer="$TOTP" --gnutls-priority="NORMAL:-VERS-ALL:+VERS-TLS1.2:+RSA:+AES-128-CBC:+SHA1" --background || echo "cant find openconnect bin"

      PASSWORD=""
      TOTP=""

      wg-quick up itsec

      exit 0
    fi

    if [ "$1" == "down" ]; then
      pkill openconnect
      wg-quick down itsec
      exit 0
    fi
  '';
}
