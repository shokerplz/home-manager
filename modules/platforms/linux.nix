{...}: {
  flake.homeModules.platformLinux = {
    my-neovim,
    ...
  }: {
    home.packages = [my-neovim];
  };
}
