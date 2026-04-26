{
  self,
  inputs,
  withSystem,
  ...
}: {
  flake.homeConfigurations."ikovalev@main-pc" = withSystem "x86_64-linux" ({
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
        {
          home = {
            username = "ikovalev";
            homeDirectory = "/home/ikovalev";
            stateVersion = "24.11";
          };

          dotfiles.noctalia.settingsFile = ./noctalia.json;
        }
      ];
    });
}
