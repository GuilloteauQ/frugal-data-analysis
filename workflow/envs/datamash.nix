{ pkgs }:

pkgs.mkShell {
  packages = [
    pkgs.datamash
  ];
}
