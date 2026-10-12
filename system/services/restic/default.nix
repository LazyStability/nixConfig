{ config, lib, ... }:
{
  services.restic.backups.odin = lib.mkIf (config.networking.hostName != "OdinNix") {
    timerConfig = {
      OnCalendar = "Fri *-*-* 20:00:00";
      Persistent = true;
    };

    paths = [
      "/mnt/data/Bilder"
      "/mnt/data/Dokumente"
    ];
    extraBackupArgs = [
      "--exclude-caches"
      "--tag scheduled"
    ];
    runCheck = true;
    checkOpts = [
      "--with-cache"
      "--read-data-subset=5G"
    ];
    pruneOpts = [
      "--keep-hourly 24"
      "--keep-daily 30"
      "--keep-monthly 6"
      "--keep-weekly 4"
      "--keep-yearly 3"
    ];
    repository = "/mnt/share/restic-backups/${config.networking.hostName}";
    passwordFile = "/run/secrets/restic-password";
  };
}
