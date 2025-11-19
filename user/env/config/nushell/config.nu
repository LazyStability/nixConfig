$env.FZF_DEFAULT_COMMAND = "fd --hidden --strip-cwd-prefix --exclude .git --exclude .cache --max-depth 9"
$env.CARAPACE_LENIENT = 1
$env.CARAPACE_BRIDGES = 'zsh'
# $env.MANPAGER = "col -bx | bat -l man -p"
$env.MANPAGECACHE = ($nu.default-config-dir | path join 'mancache.txt')
$env.RUST_BACKTRACE = 1
# # Need to clone the topiary repo to ~/.config/topiary for this to work
# git clone https://github.com/blindFS/topiary-nushell ($env.XDG_CONFIG_HOME | path join topiary)
$env.XDG_CONFIG_HOME = ($env.HOME | path join ".config")

$env.config.completions.external.completer = {|span| carapace_by_fzf $span }
$env.config.edit_mode = "vi"
$env.config.highlight_resolved_externals = true
$env.config.history.file_format = "sqlite"
$env.config.history.max_size = 10000
$env.config.show_banner = false
$env.config.table.header_on_separator = true
$env.config.table.index_mode = 'auto'
$env.config.render_right_prompt_on_last_line = true

$env.config.color_config = {
  separator: "#565f89"
  leading_trailing_space_bg: "#a9b1d6"
  header: "#9ece6a"
  date: "#bb9af7"
  filesize: "#41a6b5"
  row_index: "#1abc9c"
  bool: "#f7768e"
  int: "#9ece6a"
  duration: "#f7768e"
  range: "#f7768e"
  float: "#f7768e"
  string: "#a9b1d6"
  nothing: "#f7768e"
  binary: "#f7768e"
  cellpath: "#f7768e"
  hints: dark_gray

  shape_garbage: { fg: "#c0caf5" bg: "#f7768e" }
  shape_bool: "#41a6b5"
  shape_int: { fg: "#bb9af7" attr: b }
  shape_float: { fg: "#bb9af7" attr: b }
  shape_range: { fg: "#e0af68" attr: b }
  shape_internalcall: { fg: "#1abc9c" attr: b }
  shape_external: "#1abc9c"
  shape_externalarg: { fg: "#9ece6a" attr: b }
  shape_literal: "#41a6b5"
  shape_operator: "#e0af68"
  shape_signature: { fg: "#9ece6a" attr: b }
  shape_string: "#9ece6a"
  shape_filepath: "#41a6b5"
  shape_globpattern: { fg: "#41a6b5" attr: b }
  shape_variable: "#bb9af7"
  shape_flag: { fg: "#41a6b5" attr: b }
  shape_custom: { attr: b }
}

def --env y [...args] {
  let tmp = (mktemp -t "yazi-cwd.XXXXX")
  yazi ...$args --cwd-file $tmp
  let cwd = (open $tmp)
  if $cwd != "" and $cwd != $env.PWD {
    cd $cwd
  }
  rm -fp $tmp
}

$env.config.keybindings ++= [
  {
    name: fuzzy_complete
    modifier: control
    keycode: char_t
    mode: [emacs vi_normal vi_insert]
    event: {
      send: executehostcommand
      cmd: complete_line_by_fzf
    }
  }
]

use ~/.cache/starship/init.nu
use ~/.config/nushell/scripts/extractor.nu extract
use ~/.config/nushell/auto-pair.nu *
set auto_pair_keybindings
use ~/.config/nushell/fzf.nu [
  carapace_by_fzf
  complete_line_by_fzf
  update_manpage_cache
  # atuin_menus_func
]

if "SSH_AUTH_SOCK" not-in $env {
  $env.SSH_AUTH_SOCK = $"($env.XDG_RUNTIME_DIR)/ssh-agent"
}

$env.config = ($env.config? | default {})
$env.config.hooks = ($env.config.hooks? | default {})
$env.config.hooks.pre_prompt = (
    $env.config.hooks.pre_prompt?
    | default []
    | append {||
        direnv export json
        | from json --strict
        | default {}
        | items {|key, value|
            let value = do (
                {
                  "PATH": {
                    from_string: {|s| $s | split row (char esep) | path expand --no-symlink }
                    to_string: {|v| $v | path expand --no-symlink | str join (char esep) }
                  }
                }
                | merge ($env.ENV_CONVERSIONS? | default {})
                | get ([[value, optional, insensitive]; [$key, true, true] [from_string, true, false]] | into cell-path)
                | if ($in | is-empty) { {|x| $x} } else { $in }
            ) $value
            return [ $key $value ]
        }
        | into record
        | load-env
    }
)
source ~/.cache/carapace/init.nu
source ~/.cache/zoxide/init.nu
source ~/.config/nushell/nix.nu
