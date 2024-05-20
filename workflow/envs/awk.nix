{ pkgs }:

pkgs.mkShell {
  packages = [
    pkgs.gawk
  ];
}
