{ pkgs }:

let
    tidypolars = pkgs.rPackages.buildRPackage rec {
      name = "tidypolars";
      version = "v0.7.0";
      src = pkgs.fetchFromGitHub {
        owner = "etiennebacher";
        repo = name;
        rev = version;
        sha256 = "sha256-NNeFvhhcn3r+GTa+PEh8rGi89xe3s0Zh5gYWlsmHPnM=";
      };
      propagatedBuildInputs = with pkgs.rPackages; [ pkgs.R R_utils dplyr glue pkgs.polars tidyr tidyselect vctrs ];
    };
in

pkgs.mkShell {
  packages = [
    (pkgs.rWrapper.override { packages = with pkgs.rPackages; [ dplyr tidypolars readr]; })
  ];
}
