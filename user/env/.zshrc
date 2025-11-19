peset -U path cdpath fpath manpath
for profile in ${(z)NIX_PROFILES}; do
  fpath+=($profile/share/zsh/site-functions $profile/share/zsh/$ZSH_VERSION/functions $profile/share/zsh/vendor-completions)
done

HELPDIR="/nix/store/j424hy1p76sqywcg0vcqbaqp560hw0c5-zsh-5.9/share/zsh/$ZSH_VERSION/help"

autoload -U compinit && compinit
eval "$(/nix/store/9bj5cgf15bbx3h2ad3jqffm3n5z5s65m-zoxide-0.9.8/bin/zoxide init zsh --cmd cd)"

# History options should be set in .zshrc and after oh-my-zsh sourcing.
# See https://github.com/nix-community/home-manager/issues/177.
HISTSIZE="10000"
SAVEHIST="10000"

HISTFILE="/home/me/.zsh_history"
mkdir -p "$(dirname "$HISTFILE")"

setopt HIST_FCNTL_LOCK

# Enabled history options
enabled_opts=(
  HIST_IGNORE_DUPS HIST_IGNORE_SPACE SHARE_HISTORY
)
for opt in "${enabled_opts[@]}"; do
  setopt "$opt"
done
unset opt enabled_opts

# Disabled history options
disabled_opts=(
  APPEND_HISTORY EXTENDED_HISTORY HIST_EXPIRE_DUPS_FIRST HIST_FIND_NO_DUPS
  HIST_IGNORE_ALL_DUPS HIST_SAVE_NO_DUPS
)
for opt in "${disabled_opts[@]}"; do
  unsetopt "$opt"
done
unset opt disabled_opts

if [[ $options[zle] = on ]]; then
  source <(/nix/store/ygamr51w6f2i0fvmyxznpzcgz2sq3x7f-fzf-0.66.1/bin/fzf --zsh)
fi

function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(<"$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

if [[ $TERM != "dumb" ]]; then
  eval "$(/nix/store/y2v4dlbvp495vpcll87yqjkjsvw2028n-starship-1.24.0/bin/starship init zsh)"
fi

eval "$(/nix/store/3by7b7afc50p6v1khzj7wyml1rdmagff-direnv-2.37.1/bin/direnv hook zsh)"

if [ -z "$SSH_AUTH_SOCK" ]; then
  export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/ssh-agent
fi

alias -- cat=bat
alias -- la='eza -a'
alias -- ll='eza -l'
alias -- lla='eza -la'
alias -- ls=eza
alias -- lt='eza -T'
alias -- test='cd ..'
source /nix/store/mwy8lsv649iqz2ankmq0ylycm1fc35cj-zsh-syntax-highlighting-0.8.0/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
ZSH_HIGHLIGHT_HIGHLIGHTERS+=()
