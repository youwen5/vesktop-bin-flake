{
  pkgs,
  system,
}: {
  vesktop = with pkgs; let
    pname = "vesktop";
    version = "1.5.3";

    # Format is like:
    # `Vesktop-1.5.3-arm64.AppImage`
    # or `Vesktop-1.5.3.AppImage`

    src = let
      cpuQualifier =
        if system == "aarch64-linux"
        then "-arm64"
        else "";
      sha256Hash =
        if system == "aarch64-linux"
        then "1pvgjfbiw607z2v1cyzl16dp79myz165d1hpv8cq3rywd53nhpg0"
        else "0rcwszcnb3ir2j87fr4ibg3x6id5s7l9hh7565m732fmaaf6qlks";
    in
      fetchurl {
        url = "https://github.com/Vencord/Vesktop/releases/download/v${version}/${pname}-${version}${cpuQualifier}.AppImage";
        sha256 = sha256Hash;
      };

    appimageContents = appimageTools.extract {
      inherit pname version src;
    };

    desktopItem = makeDesktopItem {
      name = pname;
      desktopName = "Vesktop";
      exec = "vesktop %U --ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime";
      icon = "vesktop";
      startupWMClass = "Vesktop";
      genericName = "Internet Messenger";
      keywords = [
        "discord"
        "chat"
      ];
      categories = [
        "Network"
        "InstantMessaging"
        "Chat"
      ];
    };
  in
    appimageTools.wrapType2 {
      inherit pname version src;

      extraInstallCommands = ''
        mkdir -p $out/share
        cp -rt $out/share ${desktopItem}/share/applications ${appimageContents}/usr/share/icons
        chmod -R +w $out/share
        mv $out/share/icons/hicolor/{16x16,256x256}
      '';
    };
}
