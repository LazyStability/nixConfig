# Log in screen
This directory handles the login screen, powered by [greetd](https://github.com/kennylevinsen/greetd) & [Hyprland](https://github.com/hyprwm/Hyprland) & [AGS](https://github.com/Aylur/ags).
This code is "inspired" by the [ags wiki](https://aylur.github.io/ags-docs/services/greetd/)

The nix code first ensures that all needed pkgs are installed, enabled and linked to the correct directory.
The resulting greetd.toml looks like this:

```greetd.toml
[default_session]
command = "Hyprland --config /etc/greetd/hyprland.conf"
user = "greeter"

[terminal]
vt = 1
```

The result of this is the following Folder structure
```
/etc/greetd
├── greeter.js -> /etc/static/greetd/greeter.js
└── hyprland.conf -> /etc/static/greetd/hyprland.conf
```
Note: I dont know atm where nix throws the greetd.toml, but for other systems you should put it in /etc/greetd/ as well

The hyprlinks are nix stuff and also not needed if you happen to run another distro
