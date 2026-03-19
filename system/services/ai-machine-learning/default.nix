{
  pkgs,
  lib,
  config,
  ...
}:
{
  # services.llama-cpp = {
  #   port = 11434;
  # environmentVariables = {
  # OLLAMA_FLASH_ATTENTION = "1";
  # OLLAMA_KV_CACHE_TYPE = "q8_0";
  # };
  # };
  # services.open-webui = {
  # Tests do not pass for some reason
  #   enable = lib.mkForce false;
  #   port = 11111;
  #   environment = {
  #     WEBUI_AUTH = "False";
  #     OLLAMA_API_BASE_URL = "http://127.0.0.1:" + builtins.toString config.services.ollama.port;
  #   };
  # };
  environment.systemPackages = (
    if config.networking.hostName == "Kronos" then
      # lib.mkIf config.services.llama-cpp.enable [
      #     (pkgs.whisper-cpp.override { cudaSupport = true; })
      with pkgs;
      [
        opencode
        whisper-cpp-vulkan
        llama-cpp-vulkan
      ]
    else
      [ ]
  );
}
