{
  config,
  camoufox-mcp,
  ...
}: {
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
    pi-coding-agent.enable = true;
    opencode = {
      enable = true;
      settings = {
        provider."NVIDIA NIM" = {
          npm = "@ai-sdk/openai-compatible";
          name = "Nvidia NIM Free";
          options = {
            baseURL = "https://integrate.api.nvidia.com/v1";
          };
          models = {
            "moonshotai/kimi-k3" = {
              name = "Kimi-K3";
              limit = {
                context = 1000000;
                output = 16384;
              };
            };
          };
        };
      };
      settings.permission = {
        edit = "ask";
        bash = "ask";
      };
      settings.mcp.camoufox = {
        type = "local";
        command = [
          "${camoufox-mcp}/bin/camoufox-mcp"
          "--caps"
          "vision"
          "--image-responses"
          "allow"
        ];
        environment.PLAYWRIGHT_MCP_USER_DATA_DIR = "${config.xdg.cacheHome}/camoufox-mcp";
        enabled = true;
      };
      settings.mcp.searxng = {
        type = "local";
        command = [
          "npx"
          "-y"
          "mcp-searxng"
        ];
        environment.SEARXNG_URL = "https://search.ikovalev.nl";
        enabled = true;
      };
    };
    direnv.enable = true;
    gh.enable = true;
  };
}
