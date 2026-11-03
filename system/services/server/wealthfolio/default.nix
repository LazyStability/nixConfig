{ config, ... }: {
  services.wealthfolio = {
    enable = true;
    address = "0.0.0.0";
    openFirewall = true;
    port = 8088;
    authPasswordHashFile = config.sops.secrets."wealthfolio/authPasswordHashFile".path;
    secretKeyFile = config.sops.secrets."wealthfolio/secretKeyFile".path;
    corsAllowOrigins = "http://192.168.105.51:8088";
  };
}
