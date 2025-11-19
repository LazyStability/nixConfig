source ~/.cache/carapace/init.nu

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

source /nix/store/zgdv1w1gvvx58lxrk8cglxkhh3mga3r8-zoxide-nushell-config.nu

def --env y [...args] {
  let tmp = (mktemp -t "yazi-cwd.XXXXX")
  yazi ...$args --cwd-file $tmp
  let cwd = (open $tmp)
  if $cwd != "" and $cwd != $env.PWD {
    cd $cwd
  }
  rm -fp $tmp
}

use /nix/store/4llwl98hg60yv3zflr5lcc0g4bq57ab8-starship-nushell-config.nu

if "SSH_AUTH_SOCK" not-in $env {
  $env.SSH_AUTH_SOCK = $"($env.XDG_RUNTIME_DIR)/ssh-agent"
}

$env.config = ($env.config? | default {})
$env.config.hooks = ($env.config.hooks? | default {})
$env.config.hooks.pre_prompt = (
    $env.config.hooks.pre_prompt?
    | default []
    | append {||
        /nix/store/3by7b7afc50p6v1khzj7wyml1rdmagff-direnv-2.37.1/bin/direnv export json
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
