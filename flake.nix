{
  description = "A very basic flake";

  inputs = {
    #nixpkgs.url = "github:nixos/nixpkgs/23.11";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    polars-r.url = "github:pola-rs/r-polars";
  };

  outputs = { self, nixpkgs, polars-r }:
    let
      system = "x86_64-linux";
      #system = "aarch64-darwin";
      polarsOverlay = final: prev: {
        polars = polars-r.packages.${system}.default;
      };
      pkgs = import nixpkgs { inherit system; overlays = [ polarsOverlay ]; };
    in
    {
      devShells.${system} = {
        default = pkgs.mkShell {
          packages = with pkgs; [
            snakemake
            python3
          ];
        };
      } // builtins.listToAttrs (
          builtins.map (x: {name = x; value = import ./workflow/envs/${x}.nix {inherit pkgs;};}) ["awk" "mawk" "python-pandas" "python-polars" "R-tidyverse" "R-polars" "R-tidypolars"]);
    };
}
