{pkgs, ...}: {
  home.packages = with pkgs; [
    vlc
    libreoffice-qt-stable
    godot
    devenv
    orca-slicer
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
}
