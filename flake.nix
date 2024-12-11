{
  description = "Alternative Vesktop package that fetches the official binary instead of building from source.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    vesktop-bin-aarch64 = {
      url = "https://github.com/Vencord/Vesktop/releases/download/v1.5.4/vesktop-1.5.4-arm64.tar.gz";
      flake = false;
    };
    vesktop-bin-x86_64 = {
      url = "https://github.com/Vencord/Vesktop/releases/download/v1.5.4/vesktop-1.5.4.tar.gz";
      flake = false;
    };
  };

  outputs =
    inputs@{
      flake-parts,
      self,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      perSystem =
        { pkgs, system, ... }:
        {
          packages.default = pkgs.callPackage ./vesktop.nix {
            version = "1.5.4";
            src = if system == "aarch64-linux" then inputs.vesktop-bin-aarch64 else inputs.vesktop-bin-x86_64;
          };
        };
      flake = {
        overlays.default = final: prev: {
          vesktop = self.packages.${prev.system}.default;
        };
      };
    };
}
