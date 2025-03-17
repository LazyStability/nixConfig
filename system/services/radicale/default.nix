# Sources
# https://discourse.nixos.org/t/radicale-for-caldav-and-carddav-storage/48625
# https://forum.syncthing.net/t/how-to-sync-contacts-and-calendars-between-desktop-and-android-without-root/21326
{ ... }:
{
  services.radicale = {
    enable = true;
    settings = {
      server = {
        hosts = [ "localhost:5232" ];
      };
      auth = {
        type = "htpasswd";
        htpasswd_filename = "/var/lib/radicale/users";
        htpasswd_encryption = "bcrypt";
      };
      storage = {
        filesystem_folder = "/var/lib/radicale";
        type = "multifilesystem_nolock";
      };
    };
  };
}
