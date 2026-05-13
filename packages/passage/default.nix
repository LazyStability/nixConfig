{
  pkgs,
  passage,
  lib,
  ...
}:
let
  passageExtensions = import ./extensions {
    inherit pkgs;
  };
  env =
    extensions:
    let
      selected = [
        passage
      ]
      ++ (map (
        ext:
        ext.overrideAttrs (
          eold:
          let
            name = lib.last (lib.splitString "-" eold.pname);
          in
          {
            postFixup = ''
              mkdir -p $out/lib/passage/extensions
              mv $out/lib/password-store/extensions/${name}.bash $out/lib/passage/extensions/${name}.bash
              substituteInPlace $out/lib/passage/extensions/${name}.bash \
                --replace '$EXTENSIONS' "$out/lib/passage/extensions/"
              # rm $out/lib/password-store -r
            '';
          }
        )
      ) (extensions passageExtensions));
      # ++ lib.optional tombPluginSupport passExtensions.tomb;
    in
    pkgs.buildEnv {
      name = "passage-env";
      paths = selected;
      nativeBuildInputs = [ pkgs.makeWrapper ];
      buildInputs = lib.concatMap (x: x.buildInputs) selected;

      postBuild = ''
        files=$(find $out/bin/ -type f -exec readlink -f {} \;)
        if [ -L $out/bin ]; then
          rm $out/bin
          mkdir $out/bin
        fi

        for i in $files; do
          if ! [ "$(readlink -f "$out/bin/$(basename $i)")" = "$i" ]; then
            ln -sf $i $out/bin/$(basename $i)
          fi
        done

        wrapProgram $out/bin/passage \
          --set SYSTEM_EXTENSION_DIR "$out/lib/passage/extensions" \
          --set PASSAGE_EXTENSIONS_DIR "$out/lib/passage/extensions" \
          --set PASSWORD_STORE_ENABLE_EXTENSIONS true
      '';
      meta.mainProgram = "passage";
      passthru = {
        extensions = passageExtensions;
        withExtensions = env;
      };
    };
in
passage.overrideAttrs (old: {
  passthru = {
    extensions = passageExtensions;
    withExtensions = env;
  };
})
