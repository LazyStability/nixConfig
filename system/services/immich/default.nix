{ ... }: {
  services.immich = {
    port = 2283;
    openFirewall = true;
    host = "0.0.0.0";
  };
}
