#	https://wiki.nixos.org/wiki/Electric_guitar_interface_setup
{ pkgs, lib, ... }:
{
  systemd.user.services.pipewire = {
    serviceConfig = {
      MemoryDenyWriteExecute = "no";
    };
  };
  # 1. Sound Server: PipeWire with JACK/PulseAudio support
  services.pipewire = {
    enable = lib.mkForce true;
    alsa.enable = lib.mkForce true;
    alsa.support32Bit = lib.mkForce true; # Required for yabridge/wine VST bridging
    pulse.enable = lib.mkForce true;
    jack.enable = lib.mkForce true;
    extraLadspaPackages = [
      pkgs.rnnoise-plugin
    ];
    extraLv2Packages = [
      pkgs.lsp-plugins
      pkgs.rnnoise-plugin
    ];
    wireplumber = {
      enable = lib.mkForce true;
    };

    # extraConfig.pipewire =
    #   let
    #     pwRnnoiseConfig = {
    #       "context.modules" = [
    #         {
    #           "name" = "libpipewire-module-filter-chain";
    #           "args" = {
    #             "node.description" = "Noise Canceling source";
    #             "media.name" = "Noise Canceling source";
    #             "filter.graph" = {
    #               "nodes" = [
    #                 {
    #                   "type" = "ladspa";
    #                   "name" = "rnnoise";
    #                   "plugin" = "librnnoise_ladspa";
    #                   "label" = "noise_suppressor_stereo";
    #                   "control" = {
    #                     "VAD Threshold (%)" = 90.0;
    #                     "VAD Grace Period (ms)" = 20;
    #                     "Retroactive VAD Grace (ms)" = 0;
    #                   };
    #                 }
    #               ];
    #             };
    #             "audio.position" = [
    #               "FL"
    #               "FR"
    #             ];
    #             "capture.props" = {
    #               "node.name" = "effect_input.rnnoise";
    #               "node.passive" = true;
    #               "audio.rate" = 48000;
    #             };
    #             "playback.props" = {
    #               "node.name" = "effect_output.rnnoise";
    #               "media.class" = "Audio/Source";
    #               "audio.rate" = 48000;
    #             };
    #           };
    #         }
    #       ];
    #     };
    #     pwDesktopAudio = {
    #       "context.modules" = [
    #         {
    #           "name" = "libpipewire-module-loopback";
    #           "args" = {
    #             "node.description" = "Desktop Audio";
    #             "capture.props" = {
    #               "node.name" = "desktop_audio";
    #               "media.class" = "Audio/Sink";
    #               "audio.position" = [
    #                 "FL"
    #                 "FR"
    #               ];
    #             };
    #             "playback.props" = {
    #               "node.name" = "playback.desktop_audio";
    #               "audio.position" = [
    #                 "FL"
    #                 "FR"
    #               ];
    #               # make sure filter only connects to desired device
    #               # you'll need the exact node.name for this to work, regex doesn't work here
    #               # use wpctl status to find id, then wpctl inspect <id> | grep node.name to get name
    #               # node.passive is used for nodes that sit in front of sinks/sources and need to suspend together with the sink/source.
    #               "node.passive" = true;
    #             };
    #           };
    #         }
    #       ];
    #     };
    #     pwChatAudio = {
    #       "context.modules" = [
    #         {
    #           "name" = "libpipewire-module-loopback";
    #           "args" = {
    #             "node.description" = "Chat Audio";
    #             "capture.props" = {
    #               "node.name" = "chat_audio";
    #               "media.class" = "Audio/Sink";
    #               "audio.position" = [
    #                 "FL"
    #                 "FR"
    #               ];
    #             };
    #             "playback.props" = {
    #               "node.name" = "playback.chat_audio";
    #               "audio.position" = [
    #                 "FL"
    #                 "FR"
    #               ];
    #               # make sure filter only connects to desired device
    #               # you'll need the exact node.name for this to work, regex doesn't work here
    #               # use wpctl status to find id, then wpctl inspect <id> | grep node.name to get name
    #               # node.passive is used for nodes that sit in front of sinks/sources and need to suspend together with the sink/source.
    #               "node.passive" = true;
    #             };
    #           };
    #         }
    #       ];
    #     };
    #
    #   in
    #   {
    #     "70-mic-rnoise-source" = pwRnnoiseConfig;
    #     "50-desktop-audio-source" = pwDesktopAudio;
    #     "50-chat-audio-source" = pwChatAudio;
    #   };

    # Global low-latency defaults for native JACK and ALSA clients
    # Note: PulseAudio specific latency settings (pulse.min.req) are deprecated
    # in PipeWire 0.3.80+ and handled globally by default.clock.* parameters.
    # extraConfig.pipewire."92-low-latency" = {
    #   "context.properties" = {
    #     "default.clock.rate" = 48000; # Fixed rate avoids resampling latency
    #     "default.clock.quantum" = 128; # ~5ms latency at 48kHz
    #     "default.clock.min-quantum" = 32; # Allows top-tier interfaces to achieve ~1.5ms
    #     "default.clock.max-quantum" = 512;
    #   };
    # };

    # Disable node suspension to prevent audio pops on USB interfaces
    #   wireplumber.extraConfig."99-disable-suspend" = {
    #     "monitor.alsa.rules" = [
    #       {
    #         matches = [
    #           { "node.name" = "~alsa_input.*"; }
    #           { "node.name" = "~alsa_output.*"; }
    #         ];
    #         actions = {
    #           update-props = {
    #             "session.suspend-timeout-seconds" = 0;
    #           };
    #         };
    #       }
    #     ];
    #   };
  };

  # 2. Real-time Scheduling
  # RTKit handles real-time privileges via D-Bus/Polkit.
  security.rtkit.enable = lib.mkDefault true;

  # Critical: Allow unlimited memlock and high rtprio for real-time audio buffers
  security.pam.loginLimits = [
    {
      domain = "@audio";
      item = "memlock";
      type = "-";
      value = "unlimited";
    }
    {
      domain = "@audio";
      item = "rtprio";
      type = "-";
      value = "99";
    }
    {
      domain = "@audio";
      item = "nice";
      type = "-";
      value = "-19";
    }
  ];

  environment.systemPackages = with pkgs; [
    # --- Utilities & Routing ---
    qpwgraph # Visual patchbay for PipeWire
    pwvucontrol # Modern native PipeWire volume control
    # pavucontrol # Fallback for Pro Audio profile selection
    # easyeffects # System-wide real-time EQ and effects

    # --- DAWs ---
    # ardour
    # reaper
    # bitwig-studio # Native Linux commercial DAW, excellent CLAP support

    # --- Plugin Hosts ---
    carla # Modular plugin host / pedalboard, supports Windows VST via yabridge

    # --- Standalone Guitar Processors ---
    # guitarix

    # --- Plugins (LV2/CLAP) ---
    # neural-amp-modeler-lv2 # NAM: loads .nam files from tone3000.com
    # proteus # Neural network modeling (LSTM) by GuitarML
    lsp-plugins # Includes latency meter, compressors, IR loader
    rnnoise-plugin
    # calf
    # dragonfly-reverb
    # gxplugins-lv2
    # kapitonov-plugins-pack # Profile-based amp models (KPP)
    # chow-centaur # Klon Centaur emulation
    # chow-phaser
    #
    # # --- Practice & Learning ---
    # tuxguitar
    # hydrogen
    #
    # # --- Windows VST Compatibility ---
    # yabridge
    # (yabridgectl.override { wine = wineWowPackages.stable; }) # Explicit Wine path
    # wineWow64Packages.stable # Use wineWow64Packages, as wineWowPackages is deprecated
  ];
}
