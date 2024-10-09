#!/env/sh
nixos-install --root /mnt --flake .#Kronos
cp . /mnt/persist/system/etc/nixos -r
