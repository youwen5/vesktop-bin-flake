{
  description = "Alternative Vesktop package that fetches the official binary instead of building from source.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    {
      self,
      nixpkgs,
    }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
          sources = builtins.fromJSON (builtins.readFile ./sources.json);
        in
        {
          default = pkgs.callPackage ./vesktop.nix {
            inherit (sources) version;
            src = pkgs.fetchurl {
              inherit (sources.${system}) url hash;
            };
          };
        }
      );
      overlays = forAllSystems (system: {
        default = final: prev: {
          vesktop = self.packages.${prev.system}.default;
        };
      });
    };
}
