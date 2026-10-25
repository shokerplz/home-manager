{inputs, ...}: {
  flake.homeModules.desktopNoctalia = {
    config,
    lib,
    pkgs,
    ...
  }: let
    cfg = config.dotfiles.noctalia;
    quickshellPackage = inputs.noctalia.inputs.noctalia-qs.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (old: {
      patches = (old.patches or []) ++ [../../../patches/quickshell-qt612.patch];
    });
    noctaliaPackage = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
      quickshell = quickshellPackage;
    };
  in {
    options.dotfiles.noctalia.settingsFile = lib.mkOption {
      type = lib.types.path;
      default = ./noctalia.json;
      description = "Host-specific Noctalia settings JSON.";
    };

    imports = [
      inputs.noctalia.homeModules.default
    ];

    config = {
      programs.noctalia-shell = {
        enable = true;
        systemd.enable = false;
        package = noctaliaPackage.overrideAttrs (old: {
          postPatch = (old.postPatch or "") + ''
            # Qt 6.12's Color singleton shadows Noctalia's theme singleton.
            mv Commons/Color.qml Commons/NColor.qml
            find . -name '*.qml' -exec sed -i 's/\bColor\./NColor./g' {} +
            substituteInPlace \
              Modules/Bar/Widgets/MediaMini.qml \
              Services/UI/WallpaperService.qml \
              --replace-fail 'target: Color' 'target: NColor'

            substituteInPlace Services/Keyboard/ClipboardService.qml \
              --replace-fail \
                'const pasteKeys = isImage ? "wtype -M ctrl -k v" : "wtype -M ctrl -M shift v";' \
                'const pasteKeys = isImage ? "wtype -M ctrl -k v -m ctrl" : "wtype -M ctrl -M shift v -m shift -m ctrl";'
          '';
        });
        settings = (builtins.fromJSON (builtins.readFile cfg.settingsFile)).settings;
      };

      home.packages = with pkgs; [
        grim
        imagemagick
        wf-recorder
        tesseract
        xdg-utils
        jq
        satty
      ];
    };
  };
}
