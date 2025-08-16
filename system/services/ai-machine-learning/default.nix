{ ... }:
{
  services.ollama = {
    enable = true;
    environmentVariables = {
      # OLLAMA_FLASH_ATTENTION = "1";
      # OLLAMA_KV_CACHE_TYPE = "q8_0";
    };
  };
  services.open-webui = {
    enable = true;
    port = 11111;
    environment.WEBUI_AUTH = "False";
  };
}
