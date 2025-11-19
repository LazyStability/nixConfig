# Tab completions
$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional
mkdir ~/.cache/carapace
carapace _carapace nushell | save --force ~/.cache/carapace/init.nu

# Zoxide
mkdir ~/.cache/zoxide ; zoxide init nushell --cmd cd | save -f ~/.cache/zoxide/init.nu

# Starship
mkdir ~/.cache/starship ; starship init nu | save -f ~/.cache/starship/init.nu

# Shell vi mode
$env.config.edit_mode = 'vi'
