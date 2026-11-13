{
  self,
  inputs,
  ...
}: {
  flake.homeModules.commonLinuxDesktop = {
    config,
    lib,
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

    home.packages = [inputs.fleet.packages.${pkgs.stdenv.hostPlatform.system}.default];

    # SDDM sources ~/.profile before starting Hyprland: running keychain there
    # gives the whole session (and apps started from the launcher) the same
    # agent the shells use. The keys have no passphrase, so no prompt is needed.
    programs.bash.profileExtra = ''
      eval "$(SHELL=bash ${lib.getExe config.programs.keychain.package} --eval ${lib.escapeShellArgs config.programs.keychain.extraFlags} ${lib.concatStringsSep " " config.programs.keychain.keys})"
    '';

    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
    };

    home.pointerCursor = {
      enable = true;
      name = "macOS";
      size = 24;
      package = pkgs.apple-cursor;
      gtk.enable = true;
      x11.enable = true;
    };

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
      platformTheme.name = "adwaita";
      style = {
        name = "adwaita-dark";
        package = pkgs.adwaita-qt;
      };
    };
  };
}
