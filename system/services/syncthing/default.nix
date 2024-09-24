{ config,... }:
{
  # Open ports in the firewall.
  # Syncthing ports: 8384 for remote access to GUI
  # 22000 TCP and/or UDP for sync traffic
  # 21027/UDP for discovery
  # source: https://docs.syncthing.net/users/firewall.html
  networking.firewall.allowedTCPPorts = [ 8384 22000 ];
  networking.firewall.allowedUDPPorts = [ 22000 21027 ];

  services.syncthing = {
    enable = true; 
    systemService = true;
    user = "me";
    group = "wheel";
    dataDir = "/home/me/";
    configDir = "/home/me/.config/syncthing";
    relay.enable = false;
    overrideDevices = true;     # overrides any devices added or deleted through the WebUI
    overrideFolders = true;     # overrides any folders added or deleted through the WebUI
    settings = {
      devices = {
        "fedoralaptop" = {id = "Q3EZAQ7-GV27IJU-PT5TRZA-2VG3XG4-SATOQJR-D2DE62L-VUE45D4-PWWOMQP";};
      };
    folders = {
      "Zettelkasten" = { 
          path = "/home/me/Dokumente/Zettelkasten";
          devices = ["fedoralaptop"];
        };
      "Personal" = { 
          path = "/home/me/Dokumente/Personal";
          devices = ["fedoralaptop"];
        };
      "Books" = { 
          path = "/home/me/Dokumente/Books";
          devices = ["fedoralaptop"];
        };
      "dnd" = { 
          path = "/home/me/Dokumente/DNDVault";
          devices = ["fedoralaptop"];
        };
      "Uni" = { 
          path = "/home/me/Dokumente/Uni";
          devices = ["fedoralaptop"];
        };
      "OffDokumente" = { 
          path = "/home/me/Dokumente/Offizielle_Dokumente/";
          devices = ["fedoralaptop"];
        };
      "Keepass" = { 
          path = "/home/me/Dokumente/Software/Keepass/";
          devices = ["fedoralaptop"];
        };
      "Videos" = { 
          path = "/home/me/Videos/";
          devices = ["fedoralaptop"];
        };
      "Bilder" = { 
          path = "/home/me/Bilder/";
          devices = ["fedoralaptop"];
        };
      };
    };
  };
}
