{ pkgs }:

pkgs.mkShell {
  packages = [
    pkgs.miller
  ];
}
