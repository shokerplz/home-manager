{config, pkgs, ...}: {
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
    opencode = {
      enable = true;
      settings.permission = {
        edit = "ask";
        bash = "ask";
      };
      settings.mcp.playwright = {
        type = "local";
        command = [
          "${pkgs.playwright-mcp}/bin/playwright-mcp"
          "--caps"
          "vision"
          "--image-responses"
          "allow"
          "--user-data-dir"
          "${config.xdg.cacheHome}/playwright-mcp"
        ];
        enabled = true;
      };
    };
    direnv.enable = true;
    gh.enable = true;
  };
}
