# From here https://github.com/Builditluc/wiki-tui/issues/267#issuecomment-3223496743
{
  wiki-tui,
  gnugrep,
  findutils,
  gnused,
}:
wiki-tui.overrideAttrs (old: {
  nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
    gnugrep
    findutils
    gnused
  ];
  postPatch = (old.postPatch or "") + ''
    set -e
    UA='wiki-tui/0.9.1 (+https://github.com/Builditluc/wiki-tui; contact: you@example.com)'

    # For each Rust file in wiki-api/, add a UA header on request builders like:
    #   Client::... .get(endpoint|url) ...
    while IFS= read -r -d "" f; do
      changed=0

      # Inject header after common patterns of .get(...)
      for pat in '.get(endpoint)' '.get(&endpoint)' '.get(url)' '.get(&url)'; do
        if grep -q "$pat" "$f"; then
          substituteInPlace "$f" --replace "$pat" "$pat.header(reqwest::header::USER_AGENT, \"$UA\")"
          changed=1
        fi
      done

      # If we added headers, ensure USER_AGENT is imported (idempotent)
      if [ "$changed" = 1 ] && ! grep -q 'header::USER_AGENT' "$f"; then
        sed -i '1 i use reqwest::header::USER_AGENT;' "$f"
      fi
    done < <(find wiki-api -type f -name '*.rs' -print0)

    # Also add origin=* wherever the Action API base params are set (avoids CORS oddities)
    for f in $(grep -RIl --include='*.rs' '("formatversion", "2")' wiki-api || true); do
      if ! grep -q '("origin"' "$f"; then
        substituteInPlace "$f" \
          --replace '("formatversion", "2"),' \
                    '("formatversion", "2"), ("origin","*"),'
      fi
    done
  '';
})
