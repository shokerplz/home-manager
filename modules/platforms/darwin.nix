{...}: {
  flake.homeModules.platformDarwin = {
    my-neovim,
    ...
  }: {
    home.packages = [my-neovim];
    programs.bash.sessionVariables.BASH_SILENCE_DEPRECATION_WARNING = "1";
  };
}
