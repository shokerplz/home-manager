{pkgs, ...}: {
  programs = {
    firefox = {
      enable = true;
      configPath = ".mozilla/firefox";
    };
    spotify-player.enable = true;
    vscode.enable = true;
    obs-studio.enable = true;
    discord.enable = true;
    codex.enable = true;
    antigravity-cli.enable = true;
    opencode.enable = true;
    direnv.enable = true;
    gh.enable = true;
  };
}
