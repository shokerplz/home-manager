{inputs, ...}: {
  flake.homeModules.desktopNoctalia = {
    lib,
    pkgs,
    ...
  }: {
    imports = [
      inputs.noctalia.homeModules.default
    ];

    config = {
      programs.noctalia = {
        enable = true;
        systemd.enable = false;
        # Attrset (not a path) so hosts can merge their own overrides on top.
        settings = lib.importTOML ./noctalia.toml;
      };

      # Region picker for the screen recorder plugin. gpu-screen-recorder itself comes from
      # the NixOS graphical role, which also installs its capability wrapper.
      home.packages = [pkgs.slurp];
    };
  };
}
