{ pkgs }:

pkgs.mkShell {
  packages = [
    pkgs.nushell
  ];
}
