# Pseudocode for now
# I need to own the .git directory to stage and commit
# chown -R me:users .git
# 
# Build a new 
# nixos-rebuild switch --flake .#system
# nix run home-manager/master --extra-experimental-features 'nix-command flakes' -- switch .#user
