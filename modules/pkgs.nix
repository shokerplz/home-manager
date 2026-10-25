{inputs, ...}: {
  perSystem = {
    lib,
    system,
    ...
  }: let
    pkgs-unstable = import inputs.nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    _module.args = {
      inherit pkgs-unstable;
    };

    packages =
      {
        my-neovim =
          (inputs.nvf.lib.neovimConfiguration {
            pkgs = pkgs-unstable;
            modules = [../packages/nvf-config.nix];
          }).neovim;
      }
      // lib.optionalAttrs (system == "x86_64-linux") rec {
        camoufox = pkgs-unstable.callPackage ../packages/camoufox.nix {};
        camoufox-mcp = pkgs-unstable.callPackage ../packages/camoufox-mcp.nix {inherit camoufox;};
      };
  };
}
