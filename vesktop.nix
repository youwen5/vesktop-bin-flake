{
  stdenv,
  src,
  version,
  autoPatchelfHook,
  libgbm,
  libdrm,
  expat,
  libxkbcommon,
  systemd,
  alsa-lib,
  at-spi2-atk,
  libgcc,
  nss,
  pango,
  gtk3,
  nspr,
  cairo,
  cups,
  libGL,
  makeShellWrapper,
  wrapGAppsHook3,
  pipewire,
  libpulseaudio,
  xorg,
}:
stdenv.mkDerivation {
  inherit src version;

  pname = "vesktop";

  nativeBuildInputs =
    [
      autoPatchelfHook
      makeShellWrapper
      wrapGAppsHook3
      libgbm
      libdrm
      expat
      libxkbcommon
      systemd
      alsa-lib
      at-spi2-atk
      libgcc
      nss
      pango
      gtk3
      nspr
      cairo
      libGL
      pipewire
      libpulseaudio
    ]
    ++ (with xorg; [
      libxcb
      libXext
      libX11
      libXrandr
      libXdamage
      libXfixes
      libXcomposite
      cups
    ]);

  dontWrapGApps = true;

  appendRunpaths = [
    "${libGL}/lib"
    "${pipewire}/lib"
  ];

  installPhase = ''
    mkdir -p $out/bin $out/lib
    cp -r * $out/lib
    wrapProgramShell $out/lib/vesktop \
         "''${gappsWrapperArgs[@]}" \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
        --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}/"

    ln -s $out/lib/vesktop $out/bin/vesktop
    cp -r ${./share} $out/share
  '';
}
