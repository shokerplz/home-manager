{...}: {
  flake.homeModules.platformDarwin = {
	my-neovim,
	...

  }: {
	home.packages = [my-neovim];
  };
}
