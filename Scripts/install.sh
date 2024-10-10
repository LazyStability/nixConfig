#!/bin/sh
mkdir /mnt/persist/etc/nixos -p
cp . /mnt/persist/etc/nixos -r
nixos-install --root /mnt --flake .#Kronos
