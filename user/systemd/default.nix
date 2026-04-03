{ pkgs, lib, ... }:
{
  hjem.users.me.systemd.services = {
    hypridle = {
      wantedBy = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = lib.getExe pkgs.hypridle;
        Restart = "always";
        SocketBindDeny = [
          "ipv4:tcp"
          "ipv4:udp"
          "ipv6:tcp"
          "ipv6:udp"
        ];
        IPAddressDeny = "any";
        RestartSec = 10;
      };
      unitConfig = {
        After = "graphical-session.target";
        ConditionEnvironment = "WAYLAND_DISPLAY";
        X-Restart-Triggers = "$XDG_CONFIG_HOME/hypr/hypridle.conf";
        Description = "Idle daemon.";
      };
    };

    hyprpaper = {
      wantedBy = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = lib.getExe pkgs.hyprpaper;
        Restart = "always";
        RestartSec = 10;
      };
      unitConfig = {
        After = "graphical-session.target";
        ConditionEnvironment = "WAYLAND_DISPLAY";
        Description = "hyprpaper";
        PartOf = "graphical-session.target";
        X-Restart-Triggers = "$XDG_CONFIG_HOME/hypr/hyprpaper.conf";
      };
    };

    hyprsunset = {
      wantedBy = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${lib.getExe pkgs.hyprsunset} --temperature 5500";
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
      wantedby = [ "default.target" ];
      serviceConfig = {

        ExecStart = "/usr/bin/mpd-mpris -no-instance";
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
      wantedby = [ "default.target" ];
      serviceConfig = {
        # Environment=
        ExecStart = "${lib.getExe pkgs.mpd} --no-daemon";
        ExecStartPre = "${lib.getExe pkgs.bash} -c \"${pkgs.coreutils}/bin/mkdir -p ''/home/me/.local/share/mpd' '/home/me/.local/share/mpd/playlists'\"";
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
        ExecStart = "${lib.getExe pkgs.openssh "ssh-agent"} -D -a %t/ssh-agent";

      };
      unitConfig = {
        Description = "SSH authentication agent";
        Documentation = "man:ssh-agent(1)";
      };
    };

    swaync = {
      wantedBy = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${lib.getExe pkgs.swaynotificationcenter}";
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
          "$XDG_CONFIG_HOME/waybar/config.json"
          "$XDG_CONFIG_HOME/waybar/style.css"
        ];
      };
    };

    udiskie = {
      wantedBy = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${lib.getExe pkgs.udiskie}";
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
        ExecStart = pkgs.getExe pkgs.waybar;

        Restart = "on-failure";
        ExecReload = "/nix/store/ilk5qzvkadnj7lx58hfinfvl7jmhriq6-util-linux-2.41.3-bin/bin/kill -SIGUSR2 $MAINPID";
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
          "$XDG_CONFIG_HOME/waybar/config"
          "$XDG_CONFIG_HOME/waybar/style.css"
        ];
        Description = "Highly customizable Wayland bar for Sway and Wlroots based compositors.";
        Documentation = "https://github.com/Alexays/Waybar/wiki";

      };
    };

  };
}
