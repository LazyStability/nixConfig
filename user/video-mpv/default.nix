{ pkgs, ... }:
{
  programs.mpv = {
    enable = true;

    package = (
      pkgs.mpv-unwrapped.wrapper {
        scripts = with pkgs.mpvScripts; [
          modernz
          mpris
          mpv-discord
          sponsorblock
        ];

        mpv = pkgs.mpv-unwrapped.override {
          waylandSupport = true;
          sdl2Support = true;
        };
      }
    );

    config = {
      profile = "high-quality";
      ytdl-format = "bestvideo+bestaudio/best";
      input-gamepad = "yes";
      # YT-dlp
      script-opts = "ytdl_hook-ytdl_path=\"/home/me/.nix-profile/bin/yt-dlp\"";

      # Problems with yt-dlp
      # Cookie settings
      # ytdl-raw-options-append="cookies=~/Sources/Credentials/cookies.txt";
      # cookies="yes";
      # cookies-file="~/Sources/Credentials/cookies.txt";

      # Basic player
      ytdl-raw-options-append = "extractor-args=youtube:player_client=mweb";
      # This one is more reliable, but does need authentification
      # ytdl-raw-options-append="extractor-args=youtube:player-client=web_creator;po_token=web_creator.gvs+PO_TOKEN_HERE"";
    };
    extraInput = ''
      # left and right (dpad or left stick axis) will move time by 30 seconds increment
      GAMEPAD_DPAD_RIGHT seek +30
      GAMEPAD_DPAD_LEFT seek -30

      # using up/down will move to next/previous chapter if the video supports it
      GAMEPAD_DPAD_UP add chapter 1
      GAMEPAD_DPAD_DOWN add chapter -1

      # button down will pause or resume playback, the "cycle" keyword means there are different states (pause/resume)
      GAMEPAD_ACTION_DOWN cycle pause

      # button up will switch between windowed or fullscreen
      GAMEPAD_ACTION_UP cycle fullscreen

      # right trigger will increase playback speed every time it's pressed by 20%
      # left trigger resets playback speed
      GAMEPAD_RIGHT_TRIGGER multiply speed 1.2
      GAMEPAD_LEFT_TRIGGER set speed 1.0

    '';
  };
}
