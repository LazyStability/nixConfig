{pkgs, lib, ...}:
{
  home.packages = [pkgs.kitty];
  home.file = {
    ".config/kitty/relative_resize.py".source = ./relative_resize.py;
    ".config/kitty/Broadcast.py".source = ./Broadcast.py;
  };
  programs.kitty = {
    enable = true;
    settings = {
      background_opacity = lib.mkForce "0.8";
  };
    extraConfig = ''
      clear_all_shortcuts yes
      kitty_mod ctrl+shift

      # copy & paste
      map kitty_mod+c copy_to_clipboard
      map kitty_mod+v paste_from_clipboard

      ##########
      ## Tabs ##
      ##########

      # open tabs
      map kitty_mod+t new_tab
      map kitty_mod+R close_tab

      # Move in tabs
      map kitty_mod+n move_tab_forward
      map kitty_mod+p move_tab_backward

      # Rename tab
      map kitty_mod+, set_tab_title

      # Broadcast to all windows
      map f1 launch --allow-remote-control kitty +kitten broadcast

      #############
      ## Windows ##
      #############
      # Open splits
      map kitty_mod+SPACE launch --location=hsplit --cwd=current
      map kitty_mod+ENTER launch --location=vsplit --cwd=current

      # Close windows
      map kitty_mod+Q close_window

      # Kitty navigation
      map kitty_mod+j neighboring_window down
      map kitty_mod+k neighboring_window up
      map kitty_mod+h neighboring_window left
      map kitty_mod+l neighboring_window right

      # Unset the mapping to pass the keys to neovim
      map --when-focus-on var:IS_NVIM kitty_mod+j
      map --when-focus-on var:IS_NVIM kitty_mod+k
      map --when-focus-on var:IS_NVIM kitty_mod+h
      map --when-focus-on var:IS_NVIM kitty_mod+l

      # the 3 here is the resize amount, adjust as needed
      map alt+j kitten relative_resize.py down  3
      map alt+k kitten relative_resize.py up    3
      map alt+h kitten relative_resize.py left  3
      map alt+l kitten relative_resize.py right 3

      map --when-focus-on var:IS_NVIM alt+j
      map --when-focus-on var:IS_NVIM alt+k
      map --when-focus-on var:IS_NVIM alt+h
      map --when-focus-on var:IS_NVIM al

      # For linux only:
      allow_remote_control yes
      listen_on unix:@mykitty

      # Other unix systems:
      allow_remote_control yes
      listen_on unix:/tmp/mykittyt+l

      # Layouts
      enabled_layouts splits,stack
      map kitty_mod+z combine : toggle_layout stack : scroll_prompt_to_bottom
      tab_title_template "{' #' if layout_name == 'stack' else '  '}{fmt.fg.red}{bell_symbol}{activity_symbol}{fmt.fg.tab}{title}  "

    '';
  };
}
