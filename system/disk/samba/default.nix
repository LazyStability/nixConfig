{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.myModules.disks.samba;
in
{
  options.myModules.disks.samba = {
    enable = lib.mkEnableOption "Enable samba drive to home";
  };

  config = lib.mkIf cfg.enable {
    # For mount.cifs, required unless domain name resolution is not needed.
    environment.systemPackages = [ pkgs.cifs-utils ];
    fileSystems."/mnt/share" = {
      # Placeholder that will be replaced in activationScript
      device = "@samba-destination@";
      fsType = "cifs";
      options =
        let
          # this line prevents hanging on network split
          automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";

        in
        [
          "${automount_opts},credentials=${config.sops.secrets."samba/login_data".path},uid=1000,gid=100"
        ];
    };
    # Inspired from https://nixos.wiki/wiki/Agenix#Replace_inplace_strings_with_secrets
    system.activationScripts."samba-destination" = {
      text = ''
        secret_file=/run/secrets/samba/destination
        configFile=/etc/fstab
        if [ -f "$secret_file" ]; then
          secret=$(cat "$secret_file")
          ${pkgs.gnused}/bin/sed -i "s#@samba-destination@#$secret#" "$configFile"
        else
          ${pkgs.gnused}/bin/sed -i "\#@samba-destination@#d" "$configFile"
        fi
      '';
      deps = [ "setupSecrets" ];
    };
  };
}
