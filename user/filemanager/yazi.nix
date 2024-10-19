{
  pkgs,
  inputs,
  ...
}: {
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
    xdragon
    exiftool
  ];
  # Use stylix
  # stylix.targets.yazi.enable = false; # true;

  programs.yazi = {
    enable = true;
    package = inputs.yazi.packages.${pkgs.system}.default;
    enableZshIntegration = true;
    shellWrapperName = "y";
    settings = {
      preview = {
        maxWidth = 1000;
        maxHeight = 1000;
      };
    };
    plugins = {
      smart-enter = ./plugins/smart-enter.yazi;
      cmod = ./plugins/chmod.yazi;
      git = ./plugins/git.yazi;
      relative-motions = ./plugins/relative-motions.yazi;
      max-preview = ./plugins/max-preview.yazi;
    };
    keymap = {
      manager.prepend_keymap = [
        {
          on = "<C-y>";
          run = ''            shell 'dragon -x -i -T "$@"' --confirm
          '';
          desc = "drag-and-drop paste window for browsers";
        }
        {
          on = ["g" "r"];
          run = ''
            shell 'ya pub dds-cd --str "$(git rev-parse --show-toplevel)"' --confirm
          '';
          desc = "Go to [g]it [r]oot";
        }
        {
          on = "y";
          run = [
            ''
              shell 'for path in "$@"; do echo "file://$path"; done | wl-copy -t text/uri-list' --confirm
            ''
            "yank"
          ];

          desc = "Yank files to clipboard";
        }
        {
          on = "l";
          run = "plugin --sync smart-enter";
          desc = "Enter the child directory, or open the file";
        }
        {
          on = "!";
          run = ''shell "$SHELL" --block --confirm'';
          desc = "Open Shell here";
        }
        {
          on = "T";
          run = "plugin --sync max-preview";
          desc = "Maximize plugin";
        }
        #######################
        ## Relative Movement ##
        #######################
        {
          on = ["1"];
          run = "plugin relative-motions --args=1";
          desc = "Move in relative steps";
        }
        {
          on = ["2"];
          run = "plugin relative-motions --args=2";
          desc = "Move in relative steps";
        }
        {
          on = ["3"];
          run = "plugin relative-motions --args=3";
          desc = "Move in relative steps";
        }
        {
          on = ["4"];
          run = "plugin relative-motions --args=4";
          desc = "Move in relative steps";
        }
        {
          on = ["5"];
          run = "plugin relative-motions --args=5";
          desc = "Move in relative steps";
        }
        {
          on = ["6"];
          run = "plugin relative-motions --args=6";
          desc = "Move in relative steps";
        }
        {
          on = ["7"];
          run = "plugin relative-motions --args=7";
          desc = "Move in relative steps";
        }
        {
          on = ["8"];
          run = "plugin relative-motions --args=8";
          desc = "Move in relative steps";
        }
        {
          on = ["9"];
          run = "plugin relative-motions --args=9";
          desc = "Move in relative steps";
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
