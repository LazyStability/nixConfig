{ config, lib, ... }:
{
  networking.firewall.allowedTCPPorts = lib.mkIf config.services.paperless.enable [ 28981 ];
  networking.firewall.allowedUDPPorts = lib.mkIf config.services.paperless.enable [ 28981 ];
  services.paperless = {
    address = "0.0.0.0";
    passwordFile = config.sops.secrets.paperless-admin.path;
    settings = {
      PAPERLESS_CONSUMER_IGNORE_PATTERN = [
        ".DS_STORE/*"
        "desktop.ini"
      ];
      PAPERLESS_OCR_LANGUAGE = "deu+eng";
      configureTika = true;
      PAPERLESS_TIME_ZONE = "Europe/Berlin";
      PAPERLESS_OCR_USER_ARGS = {
        optimize = 1;
        pdfa_image_compression = "lossless";
      };
    };
  };
}
