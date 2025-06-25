# Sources
# https://discourse.nixos.org/t/radicale-for-caldav-and-carddav-storage/48625
# https://forum.syncthing.net/t/how-to-sync-contacts-and-calendars-between-desktop-and-android-without-root/21326
{ lib, config, ... }:
{

  networking.firewall.allowedTCPPorts = lib.mkIf config.services.radicale.enable [ 5232 ];
  networking.firewall.allowedUDPPorts = lib.mkIf config.services.radicale.enable [ 5232 ];
  services.radicale = {
    settings = {
      server = {
        hosts = [
          "0.0.0.0:5232"
          "[::]:5232"
        ];
      };
      auth = {
        type = "htpasswd";
        htpasswd_filename = "/var/lib/radicale/users";
        htpasswd_encryption = "bcrypt";
      };
      storage = {
        filesystem_folder = "/var/lib/radicale/collections";
        type = "multifilesystem_nolock";
      };
    };
  };
}
