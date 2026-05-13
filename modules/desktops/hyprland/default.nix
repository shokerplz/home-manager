{...}: {
  flake.homeModules.desktopHyprland = {
    config,
    lib,
    pkgs,
    ...
  }: let
    ipc = "${lib.getExe config.programs.noctalia-shell.package} ipc call";
  in {
    services.udiskie = {
      enable = true;
      automount = true;
      notify = true;
      tray = "auto";
    };

    home.sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = "1";
      NIXOS_OZONE_WL = "1";
    };

    home.packages = with pkgs; [
      wl-clipboard
      wtype
      nautilus
      loupe
      mpv
      celluloid
      evince
      file-roller
      gnome-calculator
      gnome-text-editor
      gnome-calendar
      pavucontrol
      blueman
      networkmanagerapplet
      zenity
      nwg-displays
      wlr-randr
      wev
    ];

    # Keep sourced host override files present so Hyprland can start cleanly.
    home.activation.createMonitorsConf = ''
      if [ ! -f "$HOME/.config/hypr/monitors.conf" ]; then
        mkdir -p "$HOME/.config/hypr"
        echo "# Managed by nwg-displays" > "$HOME/.config/hypr/monitors.conf"
      fi
    '';

    home.activation.createGamingConf = ''
            if [ ! -f "$HOME/.config/hypr/gaming.conf" ]; then
              mkdir -p "$HOME/.config/hypr"
              cat > "$HOME/.config/hypr/gaming.conf" << 'EOF'
      # Machine-specific gaming window rules
      # Example: Launch games on specific monitor
      # windowrulev2 = monitor DP-3, class:^(steam_app_.*)$
      # windowrulev2 = fullscreen, class:^(steam_app_.*)$
      EOF
            fi
    '';

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
      ];
    };

    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      systemd.enable = false;

      settings = {
        device = {
          name = "nvtk0603:00-0603:f001";
          transform = 3;
        };

        "$mod" = "SUPER";

        monitor = [",preferred,auto,1"];

        source = [
          "~/.config/hypr/monitors.conf"
          "~/.config/hypr/gaming.conf"
          "~/.config/hypr/workspaces.conf"
        ];

        general = {
          gaps_in = 5;
          gaps_out = 10;
          border_size = 2;
          "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
          "col.inactive_border" = "rgba(595959aa)";
          layout = "dwindle";
          allow_tearing = false;
          resize_on_border = true;
          extend_border_grab_area = 20;
          hover_icon_on_border = true;
        };

        decoration = {
          rounding = 10;
          dim_inactive = true;
          dim_strength = 0.15;

          blur = {
            enabled = true;
            size = 3;
            passes = 1;
          };
        };

        animations = {
          enabled = true;
          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
          animation = [
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
          ];
        };

        dwindle = {
          pseudotile = true;
          preserve_split = true;
          smart_split = true;
        };

        misc = {
          force_default_wallpaper = 0;
          disable_hyprland_logo = true;
          animate_manual_resizes = true;
        };

        cursor.no_hardware_cursors = true;

        env = [
          "XCURSOR_THEME,macOS"
          "XCURSOR_SIZE,24"
        ];

        input = {
          kb_layout = "us,ru";
          follow_mouse = 1;
          touchpad.natural_scroll = true;
          sensitivity = -0.7;
        };

        windowrulev2 = [
          "float, class:^(pavucontrol)$"
          "size (monitor_w*0.6) (monitor_h*0.6), class:^(pavucontrol)$"
          "center, class:^(pavucontrol)$"
          "float, class:^(blueman-manager)$"
          "size (monitor_w*0.5) (monitor_h*0.6), class:^(blueman-manager)$"
          "center, class:^(blueman-manager)$"
          "float, class:^(nm-connection-editor)$"
          "size (monitor_w*0.5) (monitor_h*0.6), class:^(nm-connection-editor)$"
          "center, class:^(nm-connection-editor)$"
          "float, title:^(Calendar)$"
          "center, title:^(Calendar)$"
        ];

        bind = [
          "CTRL, Q, killactive,"
          "$mod, M, exit,"
          "ALT, V, togglefloating,"
          "$mod, SPACE, exec, ${ipc} launcher toggle"
          "SUPER SHIFT, F, fullscreen"
          "CTRL, SPACE, exec, hyprctl switchxkblayout all next"
          "SUPER SHIFT, V, exec, ${ipc} launcher clipboard"
          "$mod, Tab, cyclenext, visible hist"
          "$mod SHIFT, Tab, cyclenext, prev visible hist"
          ", Print, exec, ${ipc} plugin:screen-shot-and-record screenshot"
          "$mod, 1, workspace, 1"
          "$mod, 2, workspace, 2"
          "$mod, 3, workspace, 3"
          "$mod, 4, workspace, 4"
          "$mod, 5, workspace, 5"
          "$mod, 6, workspace, 6"
          "$mod, 7, workspace, 7"
          "$mod, 8, workspace, 8"
          "$mod, 9, workspace, 9"
          "$mod SHIFT, 1, movetoworkspace, 1"
          "$mod SHIFT, 2, movetoworkspace, 2"
          "$mod SHIFT, 3, movetoworkspace, 3"
          "$mod SHIFT, 4, movetoworkspace, 4"
          "$mod SHIFT, 5, movetoworkspace, 5"
          "$mod SHIFT, 6, movetoworkspace, 6"
          "$mod SHIFT, 7, movetoworkspace, 7"
          "$mod SHIFT, 8, movetoworkspace, 8"
          "$mod SHIFT, 9, movetoworkspace, 9"
        ];

        bindel = [
          ", XF86AudioRaiseVolume, exec, ${ipc} volume increase"
          ", XF86AudioLowerVolume, exec, ${ipc} volume decrease"
          ", XF86MonBrightnessUp, exec, ${ipc} brightness increase"
          ", XF86MonBrightnessDown, exec, ${ipc} brightness decrease"
        ];

        bindl = [
          ", XF86AudioMute, exec, ${ipc} volume muteOutput"
          ", XF86AudioPlay, exec, ${ipc} media playPause"
          ", XF86AudioNext, exec, ${ipc} media next"
          ", XF86AudioPrev, exec, ${ipc} media previous"
        ];

        bindm = [
          "ALT, mouse:272, movewindow"
          "ALT, mouse:273, resizewindow"
        ];

        exec-once = [
          "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1"
          (lib.getExe config.programs.noctalia-shell.package)
        ];
      };
    };
  };
}
