{...}: {
  networking.firewall = {
    allowedUDPPorts = [51820]; # Clients and peers can use the same port, see listenport
  };
  # Enable WireGuard
  networking.wg-quick.interfaces = {
    # "wg0" is the network interface name. You can name the interface arbitrarily.
    ginyu_kronos = {
      # Determines the IP address and subnet of the client's end of the tunnel interface.
      address = ["0.100.0.7/24"];
      listenPort = 51820; # to match firewall allowedUDPPorts (without this wg uses random port numbers)

      # Path to the private key file.
      #
      # Note: The private key can also be included inline via the privateKey option,
      # but this makes the private key world-readable; thus, using privateKeyFile is
      # recommended.
      privateKeyFile = "/persist/etc/nixos/secrets/ginyu_kronos.skey";

      peers = [
        # For a client configuration, one peer entry for the server will suffice.

        {
          # Public key of the server (not a file path).
          publicKey = "6DTlU9LOxaXhcZCGXxrZ9sKrKAwicEAEZ2aA1erRXHA=";
          presharedKeyFile = "/persist/etc/nixos/secrets/ginyu_kronos.psk";

          # Forward all the traffic via VPN.
          allowedIPs = ["0.0.0.0/0" "::/0"];
          # Or forward only particular subnets
          #allowedIPs = [ "10.100.0.1" "91.108.12.0/22" ];

          # Set this to the server IP and port.
          endpoint = "46.38.253.180:51820"; # ToDo: route to endpoint not automatically configured https://wiki.archlinux.org/index.php/WireGuard#Loop_routing https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577

          # Send keepalives every 25 seconds. Important to keep NAT tables alive.
          persistentKeepalive = 25;
        }
      ];
    };
  };
  networking.networkmanager.ensureProfiles.profiles = {
    vpnHar = {
      connection = {
        type = "wireguard";
        id = "vpnHar";
      };
    };
  };
}
