{
  stdenv,
  src,
  version,
  autoPatchelfHook,
  mesa,
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
  # This option sets `--no-decommit-pooled-pages`, as electron seems to crash
  # on 16k page machines (like Apple Silicon). A patch has already entered
  # electron, so it can be removed once Vesktop picks it up
  electronPageSizeFix ? false,
}:
stdenv.mkDerivation {
  inherit src version;

  pname = "vesktop";

  nativeBuildInputs =
    [
      autoPatchelfHook
      makeShellWrapper
      wrapGAppsHook3
      mesa
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
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland --enable-features=WaylandWindowDecorations --enable-wayland-ime=true${
          if electronPageSizeFix then " " + ''--js-flags="--no-decommit-pooled-pages"'' else ""
        }}}" \
        --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}/"

    ln -s $out/lib/vesktop $out/bin/vesktop
    cp -r ${./share} $out/share
  '';
}
