#	https://wiki.nixos.org/wiki/Electric_guitar_interface_setup
{
  pkgs,
  lib,
  config,
  ...
}:
let
  desktop = config.services.pipewire.enable;
in
{
  systemd.user.services.pipewire = {
    serviceConfig = {
      MemoryDenyWriteExecute = "no";
    };
  };
  # 1. Sound Server: PipeWire with JACK/PulseAudio support
  services.pipewire = {
    alsa.enable = lib.mkForce desktop;
    alsa.support32Bit = lib.mkForce desktop; # Required for yabridge/wine VST bridging
    pulse.enable = lib.mkForce desktop;
    jack.enable = lib.mkForce desktop;
    extraLadspaPackages = [
      pkgs.rnnoise-plugin
    ];
    extraLv2Packages = [
      pkgs.lsp-plugins
      pkgs.rnnoise-plugin
    ];
    wireplumber = {
      enable = lib.mkForce desktop;
    };

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
  security.rtkit.enable = lib.mkDefault desktop;

  # Critical: Allow unlimited memlock and high rtprio for real-time audio buffers
  security.pam.loginLimits = lib.mkIf desktop [
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

  environment.systemPackages =
    with pkgs;
    lib.mkIf desktop [
      # --- Utilities & Routing ---
      # qpwgraph # Visual patchbay for PipeWire
      pwvucontrol # Modern native PipeWire volume control
      # pavucontrol # Fallback for Pro Audio profile selection
      # easyeffects # System-wide real-time EQ and effects

      # --- DAWs ---
      # ardour
      # reaper
      # bitwig-studio # Native Linux commercial DAW, excellent CLAP support

      # --- Plugin Hosts ---
      # carla # Modular plugin host / pedalboard, supports Windows VST via yabridge

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
