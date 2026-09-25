{pkgs, ...}: {
  system.stateVersion = 6;
  system.primaryUser = "admin";
  users.users.admin.home = "/Users/admin";

  nix.enable = false;

  environment.shells = [pkgs.bashInteractive];

  environment.etc.bashrc.knownSha256Hashes = [
    "8b5e3466922d1ae34bc145e21c7e53e7329a7a7b58b148b436bd954d5e651ac3"
  ];

  security.pam.services.sudo_local.enable = false;

  environment.systemPath = ["/opt/homebrew/bin" "/opt/homebrew/sbin"];

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "none";
    };

    casks = [
      "firefox"
      "godot"
      "iterm2"
      "moonlight"
      "telegram"
      "visual-studio-code"
      "vlc"
    ];

    extraConfig = ''
      cask "orcaslicer", args: { force: true }
    '';
  };
}
