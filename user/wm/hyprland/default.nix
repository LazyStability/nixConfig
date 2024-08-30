# default.nix
{ config, pkgs, inputs, userSettings, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
      settings = {
        # Setting up monitors, the third is a ghost monitor
        monitor = [
          "desc:Eizo Nanao Corporation S1901 45328108, 1280x1024@60,0x0,1"
          "desc:Eizo Nanao Corporation EV2436W 42038045, 1920x1200@60,1280x0,1"
          "Unknown-1,disabled"
      ];
        #################
        #### GLOBALS ####
        #################
        "$terminal" = userSettings.terminal;
        "$fileManager" = "dolphin";
        "$menu" = "wofi --show drun";
        "$pavucontrol" = "class:^(org.pulseaudio.pavucontrol)";

        # Sets "Windows" key as main modifier
        "$mainMod" = "SUPER";

        #################
        ### AUTOSTART ###
        #################

        # Autostart necessary processes (like notifications daemons, status bars, etc.)
        # Or execute your favorite apps at launch like this:
        "exec-once" = [ 
            "swaync"
            ];
        ####################
        ### KEYBINDINGSS ###
        ####################
        bind =[
            # Start programms
            "$mainMod,RETURN,exec,$terminal"
            "$mainMod, Q, killactive"
            "$mainMod, M,exit"
            "$mainMod, E, exec, swaync-client -t -sw"
            "$mainMod, I, exec, $menu"


            # LDUR
            "$mainMod, H, movefocus, l"
            "$mainMod, J, movefocus, d"
            "$mainMod, K, movefocus, u"
            "$mainMod, L, movefocus, r"

            # Switch workspaces with mainMod + [0-9]
            "$mainMod, 1, workspace, 1"
            "$mainMod, 2, workspace, 2"
            "$mainMod, 3, workspace, 3"
            "$mainMod, 4, workspace, 4"
            "$mainMod, 5, workspace, 5"
            "$mainMod, 6, workspace, 6"
            "$mainMod, 7, workspace, 7"
            "$mainMod, 8, workspace, 8"
            "$mainMod, 9, workspace, 9"
            "$mainMod, 0, workspace, 10"

            # Move active window to a workspace with mainMod + SHIFT + [0-9]
            "$mainMod SHIFT, 1, movetoworkspace, 1"
            "$mainMod SHIFT, 2, movetoworkspace, 2"
            "$mainMod SHIFT, 3, movetoworkspace, 3"
            "$mainMod SHIFT, 4, movetoworkspace, 4"
            "$mainMod SHIFT, 5, movetoworkspace, 5"
            "$mainMod SHIFT, 6, movetoworkspace, 6"
            "$mainMod SHIFT, 7, movetoworkspace, 7"
            "$mainMod SHIFT, 8, movetoworkspace, 8"
            "$mainMod SHIFT, 9, movetoworkspace, 9"
            "$mainMod SHIFT, 0, movetoworkspace, 10"

            # Move to scratchpads
            "$mainMod SHIFT, K, movetoworkspace, special:scratchpad_1"
            "$mainMod SHIFT, L, movetoworkspace, special:scratchpad_2"
            
            # Example special workspace (scratchpad)
            # "$mainMod, S, togglespecialworkspace, scratchpad_pavucontrol"
            # "$mainMod, S, exec, if hyprctl clients | grep pavucontrol; then echo 'scratchpad_pavucontrol respawn not needed'; else pavucontrol; fi"
            # "$mainMod SHIFT, S, movetoworkspace, special:scratchpad_pavucontrol"
            
            # Scroll through existing workspaces with mainMod + scroll
            "$mainMod, mouse_down, workspace, e+1"
            "$mainMod, mouse_up, workspace, e-1"
        ];
      # submap = "Scratchpad";
      # binde = [
      #   ", S,exec, togglespecialworkspace, magic"
      # ];
        #############
        ### INPUT ###
        #############

        # https://wiki.hyprland.org/Configuring/Variables/#input
        input ={
            "kb_layout"="de";
            "repeat_delay" = "300";
            "repeat_rate" = "50";
        };
        ####################
        ### WINDOWRULE #####
        ####################
        "windowrulev2" = [
          "float,$pavucontrol"
          "size 86% 40%,$pavucontrol"
          "move 50% 6%,$pavucontrol"
          "workspace special silent,$pavucontrol"
          "opacity 0.80,$pavucontrol"
        ];
    };
    extraConfig = ''
            ####################
            ### KEYMAPS ########
            ####################

            bind = $mainMod, D, submap, scratchpads

            submap = scratchpads

            ## AUDIO ##
            binde = , S, togglespecialworkspace, scratchpad_pavucontrol
            binde = , S, exec, if hyprctl clients | grep pavucontrol; then echo "scratchpad_pavucontrol respawn not needed"; else pavucontrol; fi

            ## BLUETOOTH ##
            binde = , D, togglespecialworkspace, scratchpad_bluetooth
            binde = , D, exec, if hyprctl clients | grep blueberry; then echo "scratchpad_bluetooth" respawn not needed; else blueberry; fi

            ## TERMINAL ##
            binde = , F, togglespecialworkspace, scratchpad_terminal
            binde = , F, exec, if hyprctl clients | grep scratchpad_term; then echo "scratchpad_term respawn not needed"; else $terminal --class scratchpad_term; fi

            ## NETWORKMANAGER ##
            binde = , H, togglespecialworkspace, scratchpad_network
            binde = , H, exec, if hyprctl clients | grep nm_connection-editor; then echo "scratchpad_network respawn not needed"; else nm-connection-editor; fi

            ## QUICK CAPTURE ##
            binde = , J, togglespecialworkspace, scratchpad_quick_capture
            binde = , J, exec, if hyprctl clients | grep scratchpad_quick_capture; then echo "scratchpad_quick_capture respawn not needed"; else $terminal --class scratchpad_quick_capture -- sh /home/me/Scripts/quickcapture.sh; fi

            ## SCRATCHPAD1 ##
            binde = , K, togglespecialworkspace, scratchpad_1

            ## SCRATCHPAD2 ##
            binde = , L, togglespecialworkspace, scratchpad_2

            binde = , catchall, submap, reset

            submap = reset



    '' ;
  };
            #
            # binde = , D, togglespecialworkspace, scratchpad_quick_capture
            #
}
