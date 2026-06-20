{
  pkgs,
  lib,
  extraPackages,
  ...
}:
{
  hjem.users.me.systemd.services = {
    hypridle = {
      wantedBy = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.hypridle}/bin/hypridle";
        Restart = "always";
        SocketBindDeny = [
          "ipv4:tcp"
          "ipv4:udp"
          "ipv6:tcp"
          "ipv6:udp"
        ];
        IPAddressDeny = "any";
        Environment = "PATH=${pkgs.hyprland}/bin:${pkgs.brightnessctl}/bin:${pkgs.hyprlock}/bin:${pkgs.dbus}/bin:${pkgs.systemd}/bin:${pkgs.coreutils}/bin";
        RestartSec = 10;
      };
      unitConfig = {
        After = "graphical-session.target";
        ConditionEnvironment = "WAYLAND_DISPLAY";
        X-Restart-Triggers = "/home/me/hypr/hypridle.conf";
        Description = "Idle daemon.";
      };
    };

    awww = {
      wantedBy = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.awww}/bin/awww-daemon";
        Restart = "always";
        RestartSec = 10;
      };
      unitConfig = {
        After = "graphical-session.target";
        ConditionEnvironment = "WAYLAND_DISPLAY";
        Description = "An Answer to your Wayland Wallpaper Woes";
        PartOf = "graphical-session.target";
      };
    };

    hyprpolkit = {
      wantedBy = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent";
        TimeoutStopSec = "5sec";
        Restart = "on-failure";
      };
      unitConfig = {
        Description = "Hyprland Polkit Authentication Agent";
        PartOf = "graphical-session.target";
        After = "graphical-session.target";
        ConditionEnvironment = "WAYLAND_DISPLAY";
      };
    };

    hyprsunset = {
      wantedBy = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.hyprsunset}/bin/hyprsunset --temperature 5500";
        Restart = "always";
        RestartSec = "10";
        # Security flags
        KeyringMode = "private";
        PrivateIPC = "yes";
        NoNewPrivileges = "yes";
        ProtectSystem = "strict";
        PrivateTmp = "disconnected";
        PrivateDevices = "true";
        PrivateMounts = "true";
        PrivateNetwork = "yes";
        ProtectHostname = "yes";
        ProtectKernelTunables = "true";
        ProtectKernelModules = "true";
        ProtectKernelLogs = "true";
        ProtectControlGroups = "true";
        ProtectProc = "ptraceable";
        ProcSubset = "pid";
        LockPersonality = "true";
        RestrictRealtime = "true";
        RestrictNamespaces = "yes";
        RestrictSUIDSGID = "yes";
        ProtectClock = "true";
        MemoryDenyWriteExecute = true;
        MountFlags = "private";
        SystemCallArchitectures = "native";
        ReadOnlyPaths = "-/";
        TemporaryFileSystem = "/:ro";
        BindReadOnlyPaths = "-/dev -/etc -/home -/nix -/run -/var";
        NoExecPaths = "-/";
        ExecPaths = "-/nix/store";
        RestrictAddressFamilies = "AF_UNIX";
        SocketBindDeny = [
          "ipv4:tcp"
          "ipv4:udp"
          "ipv6:tcp"
          "ipv6:udp"
        ];
        IPAddressDeny = "any";
        CapabilityBoundingSet = "~CAP_BLOCK_SUSPEND CAP_BPF CAP_CHOWN CAP_IPC_LOCK CAP_KILL CAP_MKNOD CAP_NET_RAW CAP_PERFMON CAP_SYS_BOOT CAP_SYS_CHROOT CAP_SYS_MODULE CAP_SYS_NICE CAP_SYS_PACCT CAP_SYS_PTRACE CAP_SYS_TIME CAP_SYS_TTY_CONFIG CAP_SYSLOG CAP_WAKE_ALARM";
        SystemCallFilter = "~@aio:EPERM @chown:EPERM @clock:EPERM @cpu-emulation:EPERM @debug:EPERM @ipc:EPERM @keyring:EPERM @memlock:EPERM @module:EPERM @mount:EPERM @obsolete:EPERM @pkey:EPERM @privileged:EPERM @raw-io:EPERM @reboot:EPERM @resources:EPERM @sandbox:EPERM @setuid:EPERM @swap:EPERM @sync:EPERM";
        UMask = 0077;

      };
    };

    mpd-mpris = {
      wantedBy = [ "default.target" ];
      serviceConfig = {

        ExecStart = "${pkgs.mpd-mpris}/bin/mpd-mpris -no-instance";
        Restart = "on-failure";
        RestartSec = "5s";
        Type = "simple";
      };
      unitConfig = {
        After = "mpd.service";
        Description = "mpd-mpris: An implementation of the MPRIS protocol for MPD";
        Requires = "mpd.service";
      };
    };

    mpd = {
      wantedBy = [ "default.target" ];
      serviceConfig = {
        # Environment=
        ExecStart = "${pkgs.mpd}/bin/mpd --no-daemon";
        ExecStartPre = "${pkgs.bash}/bin/bash -c \"${pkgs.coreutils}/bin/mkdir -p /home/me/.local/share/mpd /home/me/.local/share/mpd/playlists\"";
        Type = "notify";
      };
      unitConfig = {
        After = [
          "network.target"
          "sound.target"
        ];
        Description = "Music Player Daemon";

      };
    };
    #TODO: Main monitorservice

    ssh-agent = {
      wantedBy = [ "default.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.openssh}/bin/ssh-agent -D -a %t/ssh-agent";

      };
      unitConfig = {
        Description = "SSH authentication agent";
        Documentation = "man:ssh-agent(1)";
      };
    };

    swaync = {
      wantedBy = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.swaynotificationcenter}/bin/swaync";
        BusName = "org.freedesktop.Notifications";
        Restart = "on-failure";
        Type = "dbus";
      };
      unitConfig = {
        After = "graphical-session.target";
        ConditionEnvironment = "WAYLAND_DISPLAY";
        Description = "Swaync notification daemon";
        Documentation = "https://github.com/ErikReider/SwayNotificationCenter";
        PartOf = "graphical-session.target";
        X-Restart-Triggers = [
          "/home/me/waybar/config.json"
          "/home/me/waybar/style.css"
        ];
      };
    };

    udiskie = {
      wantedBy = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.udiskie}/bin/udiskie";
        Restart = "on-failure";
        # Security Flags
        NoNewPrivileges = "yes";
        PrivateTmp = "yes";
        ProtectSystem = "strict";
        CapabilityBoundingSet = "~";
        KeyringMode = "private";
        PrivateNetwork = "yes";
        UMask = "0077";
        SystemCallFilter = "@system-service";
        PrivateIPC = "yes";
        ProtectClock = "yes";
        ProtectKernelLogs = "yes";
        ProtectControlGroups = "yes";
        ProtectKernelModules = "yes";
        ProtectHostname = "yes";
        RestrictNamespaces = "yes";
        RestrictSUIDSGID = "yes";

      };
      unitConfig = {
        After = "graphical-session.target";
        PartOf = "graphical-session.target";
        Description = "udiskie mount daemon";
      };
    };

    waybar = {
      wantedBy = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.waybar}/bin/waybar";

        Restart = "on-failure";
        ExecReload = "${pkgs.util-linux}/bin/kill -SIGUSR2 $MAINPID";
        # Security flags
        ProtectSystem = "full";
        PrivateTmp = "disconnected";
        PrivateMounts = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        LockPersonality = true;
        RestrictRealtime = true;
        ProtectClock = true;
        MemoryDenyWriteExecute = true;
        SystemCallArchitectures = "native";
        ReadOnlyPaths = "-/";
        ReadWritePaths = [
          "-/proc/8193/task/8207/comm"
          "-/proc/8193/task/8208/comm"
          "-/run/user/1000"
        ];
        TemporaryFileSystem = "/:ro";
        BindReadOnlyPaths = [
          "-/dev"
          "-/etc"
          "-/home"
          "-/nix"
          "-/proc"
          "-/run"
          "-/sys"
          "-/var"
        ];
        BindPaths = [
          "-/proc/8193/task/8207/comm"
          "-/proc/8193/task/8208/comm"
          "-/run/user/1000"
        ];
        NoExecPaths = "-/";
        ExecPaths = "-/nix/store";
        RestrictAddressFamilies = "AF_INET AF_NETLINK AF_UNIX";
        SocketBindDeny = [
          "ipv4:tcp"
          "ipv4:udp"
          "ipv6:tcp"
          "ipv6:udp"
        ];
        IPAddressDeny = "any";
        IPAddressAllow = "127.0.0.1";
        CapabilityBoundingSet = "~CAP_BLOCK_SUSPEND CAP_BPF CAP_CHOWN CAP_IPC_LOCK CAP_MKNOD CAP_NET_RAW CAP_PERFMON CAP_SYS_BOOT CAP_SYS_CHROOT CAP_SYS_MODULE CAP_SYS_NICE CAP_SYS_PACCT CAP_SYS_PTRACE CAP_SYS_TIME CAP_SYSLOG CAP_WAKE_ALARM";
        SystemCallFilter = "~@aio:EPERM @chown:EPERM @clock:EPERM @cpu-emulation:EPERM @debug:EPERM @keyring:EPERM @memlock:EPERM @module:EPERM @mount:EPERM @obsolete:EPERM @pkey:EPERM @privileged:EPERM @raw-io:EPERM @reboot:EPERM @resources:EPERM @sandbox:EPERM @setuid:EPERM @swap:EPERM @sync:EPERM @timer:EPERM";

      };
      unitConfig = {
        PartOf = "graphical-session.target";
        After = "graphical-session.target";
        # Requisite="graphical-session.target";
        ConditionEnvironment = "WAYLAND_DISPLAY";
        X-Restart-Triggers = [
          "/home/me/waybar/config"
          "/home/me/waybar/style.css"
        ];
        Description = "Highly customizable Wayland bar for Sway and Wlroots based compositors.";
        Documentation = "https://github.com/Alexays/Waybar/wiki";

      };
    };
    gpg-setup-oneshot =
      let
        gpg-setup-script = pkgs.callPackage ../scripts/gpg-setup.nix { };
      in
      {
        unitConfig = {
          Description = "A systemd service to garantie correct setup of gpg";
          PartOf = [ "default.target" ];
        };
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${gpg-setup-script}/bin/gpg-setup";
          Environment = [ "GNUPGHOME=.config/gnupg" ];
        };
        wantedBy = [ "default.target" ];
      };
    passSecretService =
      let
        binPath = "${extraPackages.pass-secret-service}/bin/pass-secret-service";
      in
      {
        unitConfig = {
          AssertFileIsExecutable = binPath;
          Description = "Pass libsecret service";
          Documentation = "https://github.com/mdellweg/pass_secret_service";
          PartOf = [ "default.target" ];
        };

        serviceConfig = {
          Type = "dbus";
          ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p /home/me/.local/share/passSecretService";
          ExecStart = binPath + " -n --path /home/me/.local/share/passSecretService";
          BusName = "org.freedesktop.secrets";
          Environment = [ "GNUPGHOME=.config/gnupg" ];
        };

        wantedBy = [ "default.target" ];
      };
  };
  # For passSecretService
  hjem.users.me.xdg.data.files."dbus-1/services/org.freedesktop.secrets.service".source =
    "${extraPackages.pass-secret-service}/share/dbus-1/services/org.freedesktop.secrets.service";
}
