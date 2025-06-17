#!/usr/bin/env nix-shell
#! nix-shell -i bash -p jq curl cacert

# Env Variables
USERAGENT='User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.75 Safari/537.36'
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )


# Get secret
SOPS_AGE_KEY=""
echo "Enter suitable age key:"
read -rs SOPS_AGE_KEY
export SOPS_AGE_KEY
PURCHASE_KEY=$(sops -a "$SOPS_AGE_KEY" decrypt "$SCRIPT_DIR"/../system/secrets/dungeondraft.bin | tr -d "\n\r")
[[ -z $PURCHASE_KEY ]] && echo "Couldn't get purchase key" && exit 1
export SOPS_AGE_KEY=""

# Get required version
VERSION=$(rg 'version =' "$SCRIPT_DIR"/../packages/dungeondraft/default.nix | sed -r 's/^[ ]+version = "(.*)";$/\1/')
echo "Downloading Dungeondraft v$VERSION"

# Get package
TARGET_URL=$(curl \
  --compressed \
  --header 'Host: www.humblebundle.com' \
  --header 'Accept: application/json, text/plain, */*' \
  --header 'Origin: https://www.humblebundle.com' \
  --header 'Content-Type: application/json;charset=UTF-8' \
  --header "$USERAGENT" \
  --header "Accept-Language: en-US,en;q=0.9" \
  "https://www.humblebundle.com/api/v1/order/$PURCHASE_KEY?wallet_data=true&all_tpkds=true" \
  | jq -r '.subproducts[].downloads[].download_struct[] | select(.name | contains(".deb")) | .url.web | select(. | contains("'"$VERSION"'"))')

PURCHASE_KEY=""
f="/tmp/Dungeondraft-$VERSION-Linux64.deb"
touch $f
curl "$TARGET_URL" --output "$f"
nix-prefetch-url file://"$f" --type sha256
