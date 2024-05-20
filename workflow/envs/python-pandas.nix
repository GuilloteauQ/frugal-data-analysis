{ pkgs }:

pkgs.mkShell {
  packages = [
    (pkgs.python3.withPackages (ps: with ps; [ pandas ]))
 ];
}
