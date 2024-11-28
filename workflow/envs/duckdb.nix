{ pkgs }:

pkgs.mkShell {
  packages = [
    pkgs.duckdb
  ];
}
