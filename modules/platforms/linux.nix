{...}: {
  flake.homeModules.platformLinux = {
    my-neovim,
    pkgs,
    ...
  }: {
    home.packages = [
      my-neovim
      pkgs.bubblewrap
    ];
  };
}
