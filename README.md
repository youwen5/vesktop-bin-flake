# vesktop-bin flake

Provides an alternative binary package based on officially released AppImages for [Vesktop](https://github.com/Vencord/Vesktop), a custom
Discord app, than the one in `nixpkgs`. Also provides an overlay to replace `pkgs.vesktop`.

## Why

I daily-drive an Asahi Linux Macbook with a custom Mesa driver and package. This causes some applications to be
built from source since their derivations can't be substituted from `cache.nixos.org`. This is mostly fine,
except Vesktop also compiles all of Electron, taking multiple hours on each update. This flake allows you to
directly fetch a pre-built Vesktop binary from the official GitHub releases so you can avoid compiling it from source
if you are unfortunate enough to have to do so.

## Outputs

Provides three outputs: `packages.x86_64-linux.vesktop`, `packages.aarch64-linux.vesktop`, and `overlays.default`.

Self explanatory.

## Usage example

Simply add it as a flake input as usual:

```nix
{
  inputs.vesktop-bin.url = "github:youwen5/vesktop-bin-flake";

  outputs = {
  # -- snip ---
}
```

Then, instead of installing the normal `pkgs.vesktop`, you can install:

```nix
{pkgs, ...}:
{
  environment.systemPackages = [
    # make sure to use the correct CPU architecture
    inputs.vesktop-bin.packages.{pkgs.system}.vesktop
  ];
}
```

## As an overlay

Alternatively, you can add the overlay to replace the `vesktop` package in nixpkgs.

```nix
nixpkgs.overlays = [
  inputs.vesktop-bin.overlays.default;
];
```

Then just install Vesktop like normal:

```nix
{pkgs, ...}:
{
  environment.systemPackages = [
    pkgs.vesktop
  ];
}
```
