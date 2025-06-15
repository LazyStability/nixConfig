#!/bin/sh
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko ./system/disko.nix --arg device '"/dev/disk/by-id/nvme-eui.002538da21a048cb"'

