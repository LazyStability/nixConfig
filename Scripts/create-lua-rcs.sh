#!/usr/bin/env bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

NVIM_PATH="$(nix eval nixpkgs\#neovim.outPath --raw)"/share/nvim/runtime/lua
HYPRLAND_PATH="$(nix eval nixpkgs\#hyprland.outPath --raw)"/share/hypr/stub
echo "$HYPRLAND_PATH"
echo "$NVIM_PATH"

cat > "$SCRIPT_DIR"/../packages/nvim/myplugin/.luarc.json << EOF
{
	"workspace": {
		"library": [
			"$NVIM_PATH"
		]
	},
	"diagnostics": {
		"globals": ["vim"]
	}
}
EOF


cat > "$SCRIPT_DIR"/../user/env/config/hypr/.luarc.json << EOF
{
	"workspace": {
		"library": [
			"$HYPRLAND_PATH"
		]
	},
	"diagnostics": {
		"globals": ["hl"]
	}
}
EOF

