{
  self,
  inputs,
  withSystem,
  ...
}: {
  flake.darwinConfigurations.macbook = withSystem "aarch64-darwin" ({
    pkgs-unstable,
    self',
    ...
  }:
    inputs.nix-darwin.lib.darwinSystem {
      modules = [
        ./_darwin.nix
        inputs.home-manager.darwinModules.home-manager
        {
          nixpkgs.pkgs = pkgs-unstable;

          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "before-home-manager";
            extraSpecialArgs = {
              inherit (self'.packages) my-neovim;
            };
            users.admin.imports = [
              self.homeModules.commonDefault
              self.homeModules.platformDarwin
              ./_home.nix
            ];
          };
        }
      ];
    });
}
