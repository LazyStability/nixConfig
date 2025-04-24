{ config, ... }:
{
  networking.firewall = {
    allowedUDPPorts = [ 51820 ];
  };
  networking.networkmanager.ensureProfiles.profiles = {
    ginyu_kronos = {
      connection = {
        autoconnect = false;
        id = "ginyu_kronos";
        interface-name = "ginyu_kronos";
        type = "wireguard";
        uuid = "53043470-cb25-4cfb-9892-f2a914a6b10e";
      };
      ipv4 = {
        address1 = config.sops.secrets."ginyu_kronos/address1".path;
        method = "manual";
      };
      ipv6 = {
        addr-gen-mode = "stable-privacy";
        method = "ignore";
      };
      proxy = { };
      wireguard = {
        listen-port = 51820;
        private-key = config.sops.secrets."ginyu_kronos/private-key".path;
      };
      "wireguard-peer.EXTUNJXrupOHvBTZ2hWYsih40Wq5R9F5tIOVsGVSkhI=" = {
        allowed-ips = "0.0.0.0/16;";
        endpoint = config.sops.secrets."ginyu_kronos/endpoint".path;
        persistent-keepalive = "25";
        preshared-key = config.sops.secrets."ginyu_kronos/preshared-key".path;
        preshared-key-flags = "0";
      };
    };
    itsec = {
      connection = {
        autoconnect = false;
        id = "itsec";
        interface-name = "itsec";
        type = "wireguard";
        uuid = "77b38ed8-662a-47ae-b689-7e8d55377c43";
      };
      ipv4 = {
        address1 = config.sops.secrets."itsec/address1".path;
        method = "manual";
      };
      ipv6 = {
        addr-gen-mode = "default";
        method = "disabled";
      };
      proxy = { };
      wireguard = {
        mtu = "1420";
        listen-port = 51820;
        private-key = config.sops.secrets."itsec/private-key".path;
      };
      "wireguard-peer.t82G6BbTu8jrxBixXuL4I+izIwEDmX45VsZu8iwHxVQ=" = {
        allowed-ips = config.sops.secrets."itsec/allowed-ips".path;
        endpoint = config.sops.secrets."itsec/endpoint".path;
        preshared-key = config.sops.secrets."itsec/preshared-key".path;
        preshared-key-flags = "0";
      };
    };
    split_har = {
      connection = {
        autoconnect = true;
        id = "split_har";
        interface-name = "split_har";
        type = "wireguard";
        uuid = "337f30c9-0f49-4e8b-9c54-b313d6505050";
      };
      ipv4 = {
        address1 = config.sops.secrets."split_har/address1".path;
        method = "manual";
      };
      ipv6 = {
        addr-gen-mode = "default";
        method = "disabled";
      };
      proxy = { };
      wireguard = {
        listen-port = 51820;
        private-key = config.sops.secrets."split_har/private-key".path;
      };
      "wireguard-peer.CDotto29pbswL1hTrcUkU8Y52vZc2keRxtOBQWcRAS4=" = {
        allowed-ips = config.sops.secrets."split_har/allowed-ips".path;
        endpoint = config.sops.secrets."split_har/endpoint".path;
        persistent-keepalive = "25";
        preshared-key = config.sops.secrets."split_har/endpoint".path;
        preshared-key-flags = "0";
      };
    };
  };
}
