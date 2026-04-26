{inputs, ...}: {
  perSystem = {system, ...}: let
    pkgs-unstable = import inputs.nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    _module.args = {
      inherit pkgs-unstable;
    };

    packages.my-neovim =
      (inputs.nvf.lib.neovimConfiguration {
        pkgs = pkgs-unstable;
        modules = [../packages/nvf-config.nix];
      }).neovim;
  };
}
