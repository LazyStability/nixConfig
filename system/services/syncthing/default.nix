{ lib, config, ... }:
{
  # Open ports in the firewall.
  # Syncthing ports: 8384 for remote access to GUI
  # 22000 TCP and/or UDP for sync traffic
  # 21027/UDP for discovery
  # source: https://docs.syncthing.net/users/firewall.html
  networking.firewall.allowedTCPPorts = lib.mkIf config.services.syncthing.enable [
    22000
  ];
  networking.firewall.allowedUDPPorts = lib.mkIf config.services.syncthing.enable [
    22000
    21027
  ];

  services.syncthing = lib.mkIf config.services.syncthing.enable {
    systemService = true;
    cert = config.sops.secrets."syncthing/cert".path;
    key = config.sops.secrets."syncthing/key".path;
    user = lib.mkDefault "me";
    group = lib.mkDefault "users";
    dataDir = lib.mkDefault "/home/me/";
    configDir = lib.mkDefault "/home/me/.config/syncthing";
    relay.enable = false;
    overrideDevices = true; # overrides any devices added or deleted through the WebUI
    overrideFolders = true; # overrides any folders added or deleted through the WebUI
    settings = {
      options.relaysEnabled = false;
      devices = lib.attrsets.removeAttrs {
        "Nyx".id = "KD7KT6J-L5UPE5U-62W5G7C-UB7WZTQ-QM5TYJJ-6Q7ZZYR-UDRG67K-7IIATAE";
        "Phone".id = "6PXOBHV-E7HZAF2-4C2DZGF-STWF2GR-V5WRT5X-2Y3NEWD-4QO5XPL-3X7DAQ2";
        "Thor".id = "L3QDZNA-BI4XHKD-BGDOMPD-7K6JIPZ-4QOSSM5-GVZJUUP-YVMYIIM-L2RRIAI";
        "Odin".id = "YSRATIN-DMODHZK-KDQQJD7-57BQRNV-M3CBV6F-X2FG3BR-N35YK4H-JBMF4QL";
        "Kronos".id = "6RJ6Y7O-PNYWAZJ-DRG5OMC-5UUYE54-KKEMXAP-5W7MOK6-ORYPH52-M4QQBQG";
        # "Thor".id = "";
      } [ config.networking.hostName ];
      folders = with lib.lists;
        {
          "Zettelkasten" = {
            path = "/home/me/Dokumente/Zettelkasten";
            devices = remove config.networking.hostName [
              "Nyx"
              "Thor"
              "Odin"
              "Kronos"
            ];
          };
          "Personal" = {
            path = "/home/me/Dokumente/Personal";
            devices = remove config.networking.hostName [
              "Nyx"
              "Thor"
              "Odin"
              "Kronos"
            ];
          };
          "Books" = {
            path = "/home/me/Dokumente/Books";
            devices = remove config.networking.hostName [
              "Nyx"
              "Thor"
              "Odin"
              "Kronos"
            ];
          };
          "dnd" = {
            path = "/home/me/Dokumente/DNDVault";
            devices = remove config.networking.hostName [
              "Nyx"
              "Thor"
              "Odin"
              "Kronos"
            ];
          };
          "Uni" = {
            path = "/home/me/Dokumente/Uni";
            devices = remove config.networking.hostName [
              "Nyx"
              "Thor"
              "Odin"
              "Kronos"
            ];
          };
          "OffDokumente" = {
            path = "/home/me/Dokumente/Offizielle_Dokumente/";
            devices = remove config.networking.hostName [
              "Nyx"
              "Thor"
              "Odin"
              "Kronos"
            ];
          };
          "Keepass" = {
            path = "/home/me/Dokumente/Software/Keepass/";
            devices = remove config.networking.hostName [
              "Nyx"
              "Odin"
              "Thor"
              "Kronos"
            ];
          };
          "Videos" = {
            path = "/home/me/Videos/";
            devices = remove config.networking.hostName [
              "Nyx"
              "Odin"
              "Kronos"
            ];
          };
          "Bilder" = {
            path = "/home/me/Bilder/";
            devices = remove config.networking.hostName [
              "Nyx"
              "Thor"
              "Odin"
              "Kronos"
            ];
          };
          "Local Thunderbird" = {
            path = "/home/me/.thunderbird/b0b2l4n9.default-default/Mail/Local\ Folders";
            devices = remove config.networking.hostName [
              "Nyx"
              "Odin"
              "Thor"
              "Kronos"
            ];
          };
          "newsboat" = {
            path = "/home/me/.config/newsboat";
            devices = remove config.networking.hostName [
              "Nyx"
              "Odin"
              "Thor"
              "Kronos"
            ];
          };
        };
    };
  };
}
