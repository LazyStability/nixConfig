{ pkgs, ... }:
# https://wiki.nixos.org/wiki/MPD
# TODO:
{
  services.mpd = {
    enable = true;
    musicDirectory = "~/Musik";
    # Used for pipewire
    extraConfig = ''
      audio_output {
        type "pipewire"
        name "My PipeWire Output"
      }
    '';
  };
  services.mpd-mpris.enable = true;
  services.mpd-discord-rpc = {
    enable = true;
  };
  home.packages = [
    pkgs.rmpc
  ];
}
