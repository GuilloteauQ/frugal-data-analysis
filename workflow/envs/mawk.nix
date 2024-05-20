{ pkgs }:

pkgs.mkShell {
  packages = [
    pkgs.mawk
  ];
}
