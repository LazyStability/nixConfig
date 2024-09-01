# Basic, modular hyprland
Creates this filetree
```
~/.config/hypr
├── autostart.conf -> /nix/store/SomeHash-home-manager-files/.config/hypr/autostart.conf
├── hyprcursor.conf -> /nix/store/SomeHash-home-manager-files/.config/hypr/hyprcursor.conf
├── hyprland.conf -> /nix/store/SomeHash-home-manager-files/.config/hypr/hyprland.conf
├── input.conf -> /nix/store/SomeHash-home-manager-files/.config/hypr/input.conf
├── looks.conf -> /nix/store/SomeHash-home-manager-files/.config/hypr/looks.conf
└── windowsWorkspace.conf -> /nix/store/SomeHash-home-manager-files/.config/hypr/windowsWorkspace.conf
```

The default hyprland config with a few edits and split into multiple files.
Global variables are managed by nix using as little of it as possible.
