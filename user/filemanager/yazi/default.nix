{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    fd
    ffmpegthumbnailer
    p7zip
    jq
    poppler
    fd
    ripgrep
    fzf
    zoxide
    imagemagick
    dragon-drop
    exiftool
  ];
  # Use stylix
  # stylix.targets.yazi.enable = false; # true;

  # TODO: Use wrapping provided by nixpkgs instead of homemanager
  programs.yazi = {
    enableZshIntegration = true;
    shellWrapperName = "y";
    settings = {
      preview = {
        maxWidth = 1000;
        maxHeight = 1000;
      };
    };
    plugins = with pkgs.yaziPlugins; {
      # Get these plugins from here
      # https://github.com/yazi-rs/plugins
      toggle-pane = toggle-pane;
      relative-motions = relative-motions;
      chmod = chmod;
      smart-enter = smart-enter;
      smart-filter = smart-filter;
      git = git;
    };
    keymap = {
      mgr.prepend_keymap = [
        {
          on = "<C-y>";
          run = ''
            shell 'dragon-drop -x  -T "$@"' 
          '';
          desc = "drag-and-drop paste window for browsers";
        }
        {
          on = [
            "g"
            "r"
          ];
          run = ''
            shell -- ya emit cd "$(git rev-parse --show-toplevel)"
          '';
          desc = "Go to [g]it [r]oot";
        }
        {
          on = "y";
          run = [
            ''
              shell -- for path in "$@"; do echo "file://$path"; done | wl-copy -t text/uri-list
            ''
            "yank"
          ];

          desc = "Yank files to clipboard";
        }
        {
          on = "l";
          run = "plugin smart-enter";
          desc = "Enter the child directory, or open the file";
        }
        {
          on = "!";
          run = ''shell "$SHELL" --block --confirm'';
          desc = "Open Shell here";
        }
        ################
        ## Max Preview##
        ################
        {
          on = "T";
          run = "plugin toggle-pane max-preview";
          desc = "Maximize or restore the preview pane";
        }
        ###########
        ## Chmod ##
        ###########
        {
          on = [
            "c"
            "m"
          ];
          run = "plugin chmod";
          desc = "Chmod on selected files";
        }
        #######################
        ## Relative Movement ##
        #######################
        {
          on = [ "1" ];
          run = "plugin relative-motions 1";
          desc = "Move in relative steps";
        }
        {
          on = [ "2" ];
          run = "plugin relative-motions 2";
          desc = "Move in relative steps";
        }
        {
          on = [ "3" ];
          run = "plugin relative-motions 3";
          desc = "Move in relative steps";
        }
        {
          on = [ "4" ];
          run = "plugin relative-motions 4";
          desc = "Move in relative steps";
        }
        {
          on = [ "5" ];
          run = "plugin relative-motions 5";
          desc = "Move in relative steps";
        }
        {
          on = [ "6" ];
          run = "plugin relative-motions 6";
          desc = "Move in relative steps";
        }
        {
          on = [ "7" ];
          run = "plugin relative-motions 7";
          desc = "Move in relative steps";
        }
        {
          on = [ "8" ];
          run = "plugin relative-motions 8";
          desc = "Move in relative steps";
        }
        {
          on = [ "9" ];
          run = "plugin relative-motions 9";
          desc = "Move in relative steps";
        }
        {
          on = [ "F" ];
          run = "plugin smart-filter";
          desc = "Smart filter";
        }
        {
          on = [ "<C-e>" ];
          run = ''
            shell -- paths=$(for p in "$@"; do echo "$p"; done | paste -s -d,)
            thunderbird -compose "attachment='$paths'"
          '';
          desc = "send file via thunderbird";
        }
      ];
    };
    initLua = ''
       -- Show owner:group in status bar
       Status:children_add(function()
         local h = cx.active.current.hovered
         if h == nil or ya.target_family() ~= "unix" then
       	  return ui.Line {}
         end

         return ui.Line {
           ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg("magenta"),
           ui.Span(":"),
           ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg("magenta"),
           ui.Span(" "),
         }

         end, 500, Status.RIGHT)


      require("relative-motions"):setup({ show_numbers="relative", show_motion = true })
    '';
  };
}
