{pkgs, ...}: {
  home = {
    username = "admin";
    homeDirectory = "/Users/admin";
    stateVersion = "26.05";

    packages = with pkgs; [
      devenv
      glow
      sqlite
      yandex-cloud
    ];

    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/.rd/bin"
      "$HOME/.lmstudio/bin"
      "$HOME/Library/Python/3.11/bin"
    ];
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  programs.gh.enable = true;
}
