{
  self,
  inputs,
  withSystem,
  ...
}: {
  flake.homeConfigurations."ikovalev@pocket4" = withSystem "x86_64-linux" ({
    pkgs-unstable,
    self',
    ...
  }:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = pkgs-unstable;
      extraSpecialArgs = {
        inherit (self'.packages) my-neovim;
      };
      modules = [
        self.homeModules.commonLinuxDesktop
        ./_packages.nix
        ./_programs.nix
        ({
          lib,
          pkgs,
          ...
        }: let
          screenRotation = pkgs.writeShellScript "pocket4-screen-rotation" ''
            ${lib.getExe' pkgs.coreutils "stdbuf"} -oL ${lib.getExe' pkgs.iio-sensor-proxy "monitor-sensor"} --accel 2>&1 |
              while IFS= read -r line; do
                case "$line" in
                  *"orientation: normal,"*|*"orientation changed: normal"*) transform=0 ;;
                  *"orientation: left-up,"*|*"orientation changed: left-up"*) transform=1 ;;
                  *"orientation: bottom-up,"*|*"orientation changed: bottom-up"*) transform=2 ;;
                  *"orientation: right-up,"*|*"orientation changed: right-up"*) transform=3 ;;
                  *) continue ;;
                esac

                ${lib.getExe' pkgs.hyprland "hyprctl"} --batch \
                  "keyword monitor eDP-1,1600x2560@144,auto,1.6,transform,$transform ; keyword input:touchdevice:transform $transform ; keyword input:tablet:transform $transform"
              done
          '';
        in {
          home = {
            username = "ikovalev";
            homeDirectory = "/home/ikovalev";
            stateVersion = "24.11";
          };

          dotfiles.noctalia.settingsFile = ./noctalia.json;

          wayland.windowManager.hyprland.settings = {
            monitor = lib.mkBefore [
              "eDP-1,1600x2560@144,auto,1.6,transform,3"
            ];

            input = {
              touchdevice.transform = 3;
              tablet.transform = 3;
            };

            exec-once = lib.mkAfter [
              "${screenRotation}"
            ];
          };
        })
      ];
    });
}
