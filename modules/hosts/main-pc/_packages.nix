{pkgs, ...}: let
  orca-slicer-appimage = pkgs.appimageTools.wrapType2 {
    pname = "orca-slicer";
    version = "2.4.0";
    src = pkgs.fetchurl {
      url = "https://github.com/OrcaSlicer/OrcaSlicer/releases/download/v2.4.0/OrcaSlicer_Linux_AppImage_Ubuntu2404_V2.4.0.AppImage";
      hash = "sha256-RlVhl9zC+1UUDgsecMKLTE2jII8SpKJSIBKDfJ137hA=";
    };
    extraPkgs = pkgs: with pkgs; [
      gst_all_1.gst-libav
      gst_all_1.gst-plugins-bad
      (gst_all_1.gst-plugins-good.override {gtkSupport = true;})
      libsoup_3
      webkitgtk_4_1
    ];
  };
  orca-slicer-mime-types = [
    "application/sla"
    "application/vnd.ms-3mfdocument"
    "application/x-amf"
    "model/3mf"
    "model/stl"
  ];
in {
  home.packages = with pkgs; [
    vlc
    libreoffice-qt6-fresh
    godot
    devenv
    orca-slicer-appimage
    glow
    sqlite
    typora
    qbittorrent
    ghidra
    moonlight-qt
    yandex-cloud
    shadps4
    telegram-desktop
  ];

  xdg.desktopEntries.orca-slicer = {
    name = "OrcaSlicer";
    exec = "orca-slicer %F";
    terminal = false;
    categories = ["Graphics" "3DGraphics" "Engineering"];
    mimeType = orca-slicer-mime-types;
  };
}
