{ lib, ... }: rec {
  go =
    dir:
    builtins.mapAttrs (
      n: v:
      if v == "regular" && n == "default.nix" then
        dir + "/${n}"
      else if v == "directory" then
        go (dir + "/${n}")
      else
        { }
    ) (builtins.readDir dir);
  flatten =
    set:
    let
      recurse =
        path:
        lib.attrsets.mapAttrsToList (
          name: value: if builtins.isAttrs value then recurse (path ++ name) value else value
        );
    in
    lib.lists.flatten (recurse "" set);
}
