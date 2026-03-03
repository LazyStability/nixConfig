# General Plan
put packages in path/profile with nix

Wrap packages if external plugins are needed for example `nvim`, `yazi`, `mpv` in `../packages`.

Put running systems like hyprland, hyprpaper and stuff in systemd-user units.
Create the units with nix.
Use sytemd-hardening for sandboxing.
# Threat Model
Do not trust user services and apps, they only have minimal permissions to their respective `~/.config/` `~/.local/` and `~/.cache` folder and `~/Downloads`.
Do not give user programs net access per default.
Everything else has to be requested via a file picker.

The only programs that have unrestricted file access are the window manager (`hyprland`), the file picker, zsh and the terminal.

