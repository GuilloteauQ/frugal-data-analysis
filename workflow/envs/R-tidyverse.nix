{ pkgs }:

pkgs.mkShell {
  packages = [
    (pkgs.rWrapper.override { packages = with pkgs.rPackages; [ tidyverse ]; })
  ];
}
