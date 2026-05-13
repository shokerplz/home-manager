{self, ...}: {
  flake.homeModules.commonLinuxDesktop = {
    pkgs,
    ...
  }: {
    imports = [
      self.homeModules.commonDefault
      self.homeModules.commonSops
      self.homeModules.platformLinux
      self.homeModules.desktopHyprland
      self.homeModules.desktopNoctalia
    ];

    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
    };

    home.pointerCursor = {
      name = "macOS";
      size = 24;
      package = pkgs.apple-cursor;
      gtk.enable = true;
      x11.enable = true;
    };

    home.packages = with pkgs; [
      kdePackages.breeze-icons
    ];

    gtk = {
      enable = true;
      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome-themes-extra;
      };
      gtk4.theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome-themes-extra;
      };
      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = true;
      };
      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = true;
      };
    };

    dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";

    qt = {
      enable = true;
      platformTheme.name = "kde";
      style.name = "breeze";
    };

    xdg.configFile."kdeglobals".text = ''
      [General]
      ColorScheme=BreezeDark

      [Icons]
      Theme=breeze-dark

      [KDE]
      widgetStyle=Breeze
    '';
  };
}
