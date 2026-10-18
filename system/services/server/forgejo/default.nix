# https://wiki.nixos.org/wiki/Forgejo
{ config, lib, ... }:
let
  cfg = config.services.forgejo;
in
{

  networking.firewall.allowedTCPPorts = lib.mkIf cfg.enable [ 3000 ];
  networking.firewall.allowedUDPPorts = lib.mkIf cfg.enable [ 3000 ];
  services.forgejo = {
    # passwordFile = config.sops.secrets.paperless-admin.path;

    database.type = "postgres";
    # Enable support for Git Large File Storage
    lfs.enable = true;
    settings = {
      server = {
        # DOMAIN = "git.example.com";
        # You need to specify this to remove the port from URLs in the web UI.
        # ROOT_URL = "https://${srv.DOMAIN}/";
        SSH_PORT = lib.head config.services.openssh.ports;
        HTTP_PORT = 3000;
        HTTP_ADDR = "0.0.0.0";
      }; # You can temporarily allow registration to create an admin user.
      service.DISABLE_REGISTRATION = true;
      # Add support for actions, based on act: https://github.com/nektos/act
      actions = {
        ENABLED = false;
        DEFAULT_ACTIONS_URL = "github";
      };
    };
  };
  systemd.services.forgejo.preStart =
    let
      adminCmd = "${lib.getExe cfg.package} admin user";
      pwd = config.sops.secrets.forgejo-admin-password;
      user = "joe"; # Note, Forgejo doesn't allow creation of an account named "admin"
    in
    ''
      ${adminCmd} create --admin --email "root@localhost" --username ${user} --password "$(tr -d '\n' < ${pwd.path})" || true
      ## uncomment this line to change an admin user which was already created
      # ${adminCmd} change-password --username ${user} --password "$(tr -d '\n' < ${pwd.path})" || true
    '';
}
