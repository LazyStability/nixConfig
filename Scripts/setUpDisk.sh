#!/bin/sh
mkdir /etc/nixos/secrets -p
cp ./secrets/password.key /etc/nixos/secrets/
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko ./system/Kronos/disko.nix --arg device '"/dev/disk/by-id/wwn-0x5002538043584d30"'
