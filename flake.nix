{
  description = "Alternative Vesktop package that fetches the official binary instead of building from source.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }: let
    systems = ["x86_64-linux" "aarch64-linux"];
    outputs = flake-utils.lib.eachSystem systems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages = import ./package.nix {inherit system pkgs;};
    });
  in
    outputs
    // {
      overlays.default = final: prev: {
        vesktop = outputs.packages.${prev.system}.vesktop;
      };
    };
}
