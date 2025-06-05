{ lib, config, ... }:
{
  # Open ports in the firewall.
  # Syncthing ports: 8384 for remote access to GUI
  # 22000 TCP and/or UDP for sync traffic
  # 21027/UDP for discovery
  # source: https://docs.syncthing.net/users/firewall.html
  networking.firewall.allowedTCPPorts = lib.mkIf config.services.syncthing.enable [ 22000 ];
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
      devices = lib.mkDefault {
        "fedoralaptop" = {
          id = "Q3EZAQ7-GV27IJU-PT5TRZA-2VG3XG4-SATOQJR-D2DE62L-VUE45D4-PWWOMQP";
        };
        "Phone" = {
          id = "6PXOBHV-E7HZAF2-4C2DZGF-STWF2GR-V5WRT5X-2Y3NEWD-4QO5XPL-3X7DAQ2";
        };
        "Odin" = {
          id = "YSRATIN-DMODHZK-KDQQJD7-57BQRNV-M3CBV6F-X2FG3BR-N35YK4H-JBMF4QL";
        };
      };
      folders = lib.mkDefault {
        "Zettelkasten" = {
          path = "/home/me/Dokumente/Zettelkasten";
          devices = [
            "fedoralaptop"
            "Odin"
          ];
        };
        "Personal" = {
          path = "/home/me/Dokumente/Personal";
          devices = [
            "fedoralaptop"
            "Odin"
          ];
        };
        "Books" = {
          path = "/home/me/Dokumente/Books";
          devices = [
            "fedoralaptop"
            "Odin"
          ];
        };
        "dnd" = {
          path = "/home/me/Dokumente/DNDVault";
          devices = [
            "fedoralaptop"
            "Odin"
          ];
        };
        "Uni" = {
          path = "/home/me/Dokumente/Uni";
          devices = [
            "fedoralaptop"
            "Odin"
          ];
        };
        "OffDokumente" = {
          path = "/home/me/Dokumente/Offizielle_Dokumente/";
          devices = [
            "fedoralaptop"
            "Odin"
          ];
        };
        "Keepass" = {
          path = "/home/me/Dokumente/Software/Keepass/";
          devices = [
            "fedoralaptop"
            "Odin"
          ];
        };
        "Videos" = {
          path = "/home/me/Videos/";
          devices = [
            "fedoralaptop"
            "Odin"
          ];
        };
        "Bilder" = {
          path = "/home/me/Bilder/";
          devices = [
            "fedoralaptop"
            "Odin"
          ];
        };
        "Local Thunderbird" = {
          path = "/home/me/.thunderbird/b0b2l4n9.default-default/Mail/Local\ Folders";
          devices = [
            "fedoralaptop"
            "Odin"
          ];
        };
        "newsboat" = {
          path = "/home/me/.newsboat";
          devices = [
            "fedoralaptop"
            "Odin"
          ];
        };
      };
    };
  };
}
