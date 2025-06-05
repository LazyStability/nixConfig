{
  pkgs,
  inputs,
  ...
}:
#   let wezterm =  pkgs.wezterm.overrideAttrs (old:{
#     version = "main";
#     });
#   in
{
  # home.packages = [
  #   wezterm
  # ];
  programs.wezterm = {
    package = inputs.wezterm-flake.packages.${pkgs.system}.default;
    enableZshIntegration = true;
    extraConfig = ''
      return {
        font = wezterm.font("FiraCode Nerd Font", {weight="Light", stretch="Normal", style="Normal"}), -- /nix/store/zg48bmq09468wrry2yfai3blw365fl0g-nerdfonts-3.2.1/share/fonts/truetype/NerdFonts/FiraCodeNerdFont-Light.ttf, FontConfig
        font = wezterm.font("FiraCode Nerd Font", {weight="Regular", stretch="Normal", style="Normal"}), -- /nix/store/zg48bmq09468wrry2yfai3blw365fl0g-nerdfonts-3.2.1/share/fonts/truetype/NerdFonts/FiraCodeNerdFont-Regular.ttf, FontConfig
        font = wezterm.font("FiraCode Nerd Font", {weight=450, stretch="Normal", style="Normal"}), -- (AKA: FiraCode Nerd Font Ret) /nix/store/zg48bmq09468wrry2yfai3blw365fl0g-nerdfonts-3.2.1/share/fonts/truetype/NerdFonts/FiraCodeNerdFont-Retina.ttf, FontConfig
        font = wezterm.font("FiraCode Nerd Font", {weight="Medium", stretch="Normal", style="Normal"}), -- (AKA: FiraCode Nerd Font Med) /nix/store/zg48bmq09468wrry2yfai3blw365fl0g-nerdfonts-3.2.1/share/fonts/truetype/NerdFonts/FiraCodeNerdFont-Medium.ttf, FontConfig
        font = wezterm.font("FiraCode Nerd Font", {weight="DemiBold", stretch="Normal", style="Normal"}), -- (AKA: FiraCode Nerd Font SemBd) /nix/store/zg48bmq09468wrry2yfai3blw365fl0g-nerdfonts-3.2.1/share/fonts/truetype/NerdFonts/FiraCodeNerdFont-SemiBold.ttf, FontConfig
        font = wezterm.font("FiraCode Nerd Font", {weight="Bold", stretch="Normal", style="Normal"}), -- /nix/store/zg48bmq09468wrry2yfai3blw365fl0g-nerdfonts-3.2.1/share/fonts/truetype/NerdFonts/FiraCodeNerdFont-Bold.ttf, FontConfig
        font = wezterm.font("FiraCode Nerd Font Mono", {weight="Light", stretch="Normal", style="Normal"}), -- /nix/store/zg48bmq09468wrry2yfai3blw365fl0g-nerdfonts-3.2.1/share/fonts/truetype/NerdFonts/FiraCodeNerdFontMono-Light.ttf, FontConfig
        font = wezterm.font("FiraCode Nerd Font Mono", {weight="Regular", stretch="Normal", style="Normal"}), -- /nix/store/zg48bmq09468wrry2yfai3blw365fl0g-nerdfonts-3.2.1/share/fonts/truetype/NerdFonts/FiraCodeNerdFontMono-Regular.ttf, FontConfig
        font = wezterm.font("FiraCode Nerd Font Mono", {weight=450, stretch="Normal", style="Normal"}), -- (AKA: FiraCode Nerd Font Mono Ret) /nix/store/zg48bmq09468wrry2yfai3blw365fl0g-nerdfonts-3.2.1/share/fonts/truetype/NerdFonts/FiraCodeNerdFontMono-Retina.ttf, FontConfig
        font = wezterm.font("FiraCode Nerd Font Mono", {weight="Medium", stretch="Normal", style="Normal"}), -- (AKA: FiraCode Nerd Font Mono Med) /nix/store/zg48bmq09468wrry2yfai3blw365fl0g-nerdfonts-3.2.1/share/fonts/truetype/NerdFonts/FiraCodeNerdFontMono-Medium.ttf, FontConfig
        font = wezterm.font("FiraCode Nerd Font Mono", {weight="DemiBold", stretch="Normal", style="Normal"}), -- (AKA: FiraCode Nerd Font Mono SemBd) /nix/store/zg48bmq09468wrry2yfai3blw365fl0g-nerdfonts-3.2.1/share/fonts/truetype/NerdFonts/FiraCodeNerdFontMono-SemiBold.ttf, FontConfig
        font = wezterm.font("FiraCode Nerd Font Mono", {weight="Bold", stretch="Normal", style="Normal"}), -- /nix/store/zg48bmq09468wrry2yfai3blw365fl0g-nerdfonts-3.2.1/share/fonts/truetype/NerdFonts/FiraCodeNerdFontMono-Bold.ttf, FontConfig
        font = wezterm.font("FiraCode Nerd Font Propo", {weight="Light", stretch="Normal", style="Normal"}), -- /nix/store/zg48bmq09468wrry2yfai3blw365fl0g-nerdfonts-3.2.1/share/fonts/truetype/NerdFonts/FiraCodeNerdFontPropo-Light.ttf, FontConfig
        font = wezterm.font("FiraCode Nerd Font Propo", {weight="Regular", stretch="Normal", style="Normal"}), -- /nix/store/zg48bmq09468wrry2yfai3blw365fl0g-nerdfonts-3.2.1/share/fonts/truetype/NerdFonts/FiraCodeNerdFontPropo-Regular.ttf, FontConfig
        font = wezterm.font("FiraCode Nerd Font Propo", {weight=450, stretch="Normal", style="Normal"}), -- (AKA: FiraCode Nerd Font Propo Ret) /nix/store/zg48bmq09468wrry2yfai3blw365fl0g-nerdfonts-3.2.1/share/fonts/truetype/NerdFonts/FiraCodeNerdFontPropo-Retina.ttf, FontConfig
        font = wezterm.font("FiraCode Nerd Font Propo", {weight="Medium", stretch="Normal", style="Normal"}), -- (AKA: FiraCode Nerd Font Propo Med) /nix/store/zg48bmq09468wrry2yfai3blw365fl0g-nerdfonts-3.2.1/share/fonts/truetype/NerdFonts/FiraCodeNerdFontPropo-Medium.ttf, FontConfig
        font = wezterm.font("FiraCode Nerd Font Propo", {weight="DemiBold", stretch="Normal", style="Normal"}), -- (AKA: FiraCode Nerd Font Propo SemBd) /nix/store/zg48bmq09468wrry2yfai3blw365fl0g-nerdfonts-3.2.1/share/fonts/truetype/NerdFonts/FiraCodeNerdFontPropo-SemiBold.ttf, FontConfig
        font = wezterm.font("FiraCode Nerd Font Propo", {weight="Bold", stretch="Normal", style="Normal"}), -- /nix/store/zg48bmq09468wrry2yfai3blw365fl0g-nerdfonts-3.2.1/share/fonts/truetype/NerdFonts/FiraCodeNerdFontPropo-Bold.ttf, FontConfig  font = wezterm.font "FiraCode Nerd Font",



        enable_wayland = true,
        keys = {
        -- Search for (git) hashes
        {
          key = 'H',
          mods = 'SHIFT|CTRL',
          action = wezterm.action.Search { Regex = '[a-f0-9]{6,}'}
        }
        }
      }
    '';
  };
}
