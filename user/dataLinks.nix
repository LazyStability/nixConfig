{...}: {
  systemd.user.tmpfiles.rules = [
    "L+ /home/me/Musik - - - - /data/Musik"
    "L+ /home/me/Bilder - - - - /data/Bilder"
    "L+ /home/me/Videos - - - - /data/Videos"
    "L+ /home/me/Dokumente - - - - /data/Dokumente"
    "L+ /home/me/Downloads - - - - /data/Downloads"
    "L+ /home/me/Software - - - - /data/Software"
  ];
}
