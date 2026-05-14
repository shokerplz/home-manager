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
        }: {
          home = {
            username = "ikovalev";
            homeDirectory = "/home/ikovalev";
            stateVersion = "24.11";
          };

          dotfiles.noctalia.settingsFile = ./noctalia.json;

          wayland.windowManager.hyprland.settings = {
            input = {
              touchdevice.transform = 3;
              tablet.transform = 3;
            };

            exec-once = lib.mkAfter [
              "${lib.getExe pkgs.iio-hyprland} --transform 3,0,1,2 eDP-1"
            ];
          };
        })
      ];
    });
}
