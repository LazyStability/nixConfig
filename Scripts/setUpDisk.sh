#!/bin/sh
mkdir /etc/secrets -p
cp ./secrets/password.key /etc/secrets/
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko ./system/Kronos/disko.nix --arg device '"/dev/disk/by-id/wwn-0x5002538043584d30"'
