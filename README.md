# vesktop-bin flake

Provides an alternative binary package based on officially released binaries
for [Vesktop](https://github.com/Vencord/Vesktop), a custom Discord app, to
avoid building the one in `nixpkgs` from source. Also provides an overlay to
replace `pkgs.vesktop`.

It automatically updates as soon as a new Vesktop release is published.

## Why

I daily-drive an Asahi Linux Macbook with a custom Mesa driver and package.
This leads to some really weird glitches with the `nixpkgs` Vesktop package.
Also in general electron apps are not too stable in `nixpkgs`. If you're
experiencing any weird issues with the Vesktop in `nixpkgs`, try this flake!

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
{pkgs, inputs, ...}:
{
  environment.systemPackages = [
    # make sure to use the correct CPU architecture
    inputs.vesktop-bin.packages.${pkgs.system}.vesktop
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
