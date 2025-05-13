{ config, lib, ... }:
{
  config = lib.mkIf (config.myHomeModules.desktopEnvironment.select == "kde") { };
}
