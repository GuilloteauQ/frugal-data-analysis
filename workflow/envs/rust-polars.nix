{ pkgs }:

pkgs.mkShell {
  packages = [
    pkgs.cargo pkgs.rustc
    pkgs.darwin.libiconv
  ];
}
