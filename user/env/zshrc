typeset -U path cdpath fpath manpath


HISTSIZE="10000"
SAVEHIST="10000"
SAVEHIST=$HISTSIZE
HISTDUP=erase

set_opts=(
  HIST_FCNTL_LOCK HIST_IGNORE_DUPS HIST_IGNORE_SPACE SHARE_HISTORY
  NO_APPEND_HISTORY NO_EXTENDED_HISTORY NO_HIST_EXPIRE_DUPS_FIRST
  NO_HIST_FIND_NO_DUPS NO_HIST_IGNORE_ALL_DUPS NO_HIST_SAVE_NO_DUPS
)

# Set shell options
for opt in "${set_opts[@]}"; do
  setopt "$opt"
done
unset opt set_opts


bindkey '^f' autosuggest-accept

eval "$(starship init zsh)"
source <(fzf --zsh)

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}
