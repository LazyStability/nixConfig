{
  pkgs,
  lib,
  config,
  osConfig,
  ...
}:
let
  cfg = config.myHomeModules.gaming.screen-recording;
in
{
  options.myHomeModules.gaming.screen-recording = {
    enable = lib.mkEnableOption "Enable screen recording";
    bitrate = lib.mkOption {
      default = "auto";
      type = lib.types.enum [
        "auto"
        "cbr"
        "vbr"
        "qb"
      ];
      description = ''
        Select the bitrate mode:
        - qp for constant quality
        - cbr constant bitrate
        - vbr variable bitrate
        - or auto which defaults to qb most often
      '';
    };
    quality = lib.mkOption {
      default = if (cfg.bitrate == "cbr") then 4000 else "very_high";
      type =
        if (cfg.bitrate == "cbr") then
          lib.types.int
        else
          lib.types.enum [
            "medium"
            "high"
            "very_high"
            "ultra"
          ];
      description = ''
        Video quality. Should be either 'medium', 'high', 'very_high' or 'ultra' when using 'bitrate qp' or 'bitrate vbr' options, and 'bitrate qp' is the default option used.
        'high' is the recommended option when live streaming or when you have a slower harddrive.
        When using '-bm cbr' option then this is option is instead used to specify the video bitrate in kbps.
        Optional when using 'bitrate qp' or 'bitrate vbr' options, set to 'very_high' be default.
        Required when using 'bitrate cbr' option.
      '';
    };
    framerate = lib.mkOption {
      default = 60;
      type = lib.types.int;
      description = ''Select the framerate you want to record with'';
    };
    codec = lib.mkOption {
      default = "hevc";
      type = lib.types.str;
      description = ''Select the codec you want to record with'';
    };
    videoFormat = lib.mkOption {
      default = "mp4";
      type = lib.types.str;
      description = ''Select the file type you want to save your recordings with'';
    };
    videoDirectory = lib.mkOption {
      default = "${config.home.homeDirectory}/Videos/shadowplay";
      type = lib.types.path;
      description = ''Select the directory you want to save your recordings to'';
    };
    shadowplay = {
      enable = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "Enable shadowplay like systemd service";
      };
      screen = lib.mkOption {
        default = "DP-2";
        type = lib.types.str;
        description = ''Select the screen you want to record with. Will only be used if the security is applied systemwide.'';
      };
      duration = lib.mkOption {
        default = 30;
        type = lib.types.int;
        description = ''The duration of the shadowplay'';
      };
    };
  };
  config = {
    home.packages =
      let
        ## Scripts ##
        ## Source: https://git.dec05eba.com/gpu-screen-recorder/tree/scripts
        toggle-recording-script = pkgs.writeShellApplication {
          name = "toggle-recording-script";
          runtimeInputs = [ pkgs.killall ];
          text =
            (lib.optionalString cfg.shadowplay.enable "systemctl --user stop shadowplay")
            + ''

              # Simple script to start recording if it's not recording and stop recording
              # if it's already recording. This script can be bound to a single hotkey
              # to start/stop recording with a single hotkey.

              killall -SIGINT -q gpu-screen-recorder && exit 0
              video="${cfg.videoDirectory}/$(date +"Video_%Y-%m-%d_%H-%M-%S.mp4")"
              gpu-screen-recorder -w portal \
                -c ${cfg.videoFormat} \
                -bm ${cfg.bitrate} \
                -q  ${builtins.toString cfg.quality} \
                -f ${builtins.toString cfg.framerate} \
                -a default_output \
                -o "$video" -k ${cfg.codec}
              notify-send -t 2000 -u low "GPU Screen Recorder" "Video saved to $video"

            ''
            + (lib.optionalString cfg.shadowplay.enable "systemctl --user start shadowplay");
        };
        save-replay-script = pkgs.writeShellApplication {
          name = "save-recording-script";
          runtimeInputs = [ pkgs.killall ];
          text = ''
            killall -SIGUSR1 gpu-screen-recorder && sleep 0.5 && notify-send -a "Shadowplay" -t 1500 -u low -- "GPU Screen Recorder" "Replay saved"
          '';
        };
      in
      (lib.optional cfg.shadowplay.enable save-replay-script)
      ++ (lib.optional cfg.enable toggle-recording-script);

    systemd.user.services.shadowplay = lib.mkIf cfg.shadowplay.enable {
      # Save a video using `killall -SIGUSR1 gpu-screen-recorder` (or any other way to send a SIGUSR1 signal to gpu-screen-recorder)
      Unit = {
        Description = "A shadowplay equivelant using gpu-screen-recorder as a replay service";
        Documentation = [ "gpu-screen-recorder --help" ];
      };
      Install.WantedBy = [ "default.target" ];
      Service =
        let
          cfgsh = cfg.shadowplay;
          # Needs a security wrapper which is getting enabled in the system gaming module, otherwise it fails with permission errors
          videoSource = if osConfig.programs.gpu-screen-recorder.enable then cfgsh.screen else "portal";
        in
        {
          ExecStart = ''
            ${lib.getExe pkgs.gpu-screen-recorder} \
              -r  ${builtins.toString cfgsh.duration} \
              -bm ${cfg.bitrate} \
              -q  ${builtins.toString cfg.quality} \
              -w  ${videoSource} \
              -c  ${cfg.videoFormat} \
              -f  ${builtins.toString cfg.framerate} \
              -a  'default_output|default_input' \
              -o  ${cfg.videoDirectory} \
              -k  ${cfg.codec} \
              -restore-portal-session yes
          '';

          ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p ${cfg.videoDirectory}";
          KillSignal = "SIGINT";
          Restart = "on-failure";
          RestartSec = "5s";
        };
    };
  };
}
