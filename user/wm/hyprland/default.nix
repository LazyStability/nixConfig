# default.nix
{ config, pkgs, inputs, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "exec-once" = [ 
        "[workspace 1 silent] kitty"
        "[workspace 2 silent] kitty"
      ];

      bind =[
        "SUPER,RETURN,exec,kitty"
        "SUPER,M,exit"
        ];
      input ={
        "kb_layout"="de";
        "repeat_delay" = "300";
        "repeat_rate" = "50";
      };
    };
    # extraConfig = ''
    #   input{
    #       kb_layout=de
    #   }
    # '';
  };
}
