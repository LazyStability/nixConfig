{ pkgs, ... }:
# https://wiki.nixos.org/wiki/MPD
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
      decoder {
        plugin "audiofile"
        enabled "yes"
      }
    '';
  };
  services.mpd-mpris.enable = true;
  home.packages = [
    pkgs.rmpc
  ];
}
