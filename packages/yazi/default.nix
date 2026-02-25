{
  fetchFromGitHub,
  yazi,
  yaziPlugins,
  fd,
  ffmpegthumbnailer,
  jq,
  ripgrep,
  fzf,
  zoxide,
  imagemagick,
  dragon-drop,
  exiftool,
  poppler-utils,
  _7zz,
  chafa,
  resvg,

}:
yazi.override {
  plugins = {
    inherit (yaziPlugins)
      toggle-pane
      relative-motions
      chmod
      smart-enter
      smart-filter
      git
      ;
  };
  initLua = ./init.lua;
  settings = {
    yazi.preview = {
      maxWidth = 1000;
      maxHeight = 1000;
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
  };
  optionalDeps = [
    fd
    ffmpegthumbnailer
    _7zz
    chafa
    resvg
    jq
    poppler-utils
    fd
    ripgrep
    fzf
    zoxide
    imagemagick
    dragon-drop
    exiftool
  ];
}
