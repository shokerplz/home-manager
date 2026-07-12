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
      settings.agent = {
        explore = {
          model = "openai/gpt-5.6-luna";
          variant = "low";
          steps = 8;
        };
        general = {
          model = "openai/gpt-5.6-terra";
          variant = "medium";
          steps = 18;
        };
        reviewer = {
          description = "Use proactively after non-trivial implementation to independently review the current diff for correctness, regressions, security issues, and missing tests";
          mode = "subagent";
          model = "openai/gpt-5.6-sol";
          variant = "high";
          steps = 12;
          permission = {
            "*" = "deny";
            read = "allow";
            glob = "allow";
            grep = "allow";
            list = "allow";
            lsp = "allow";
            bash = {
              "*" = "deny";
              "git status --short" = "allow";
              "git diff --no-ext-diff --no-textconv HEAD" = "allow";
            };
          };
          prompt = ''
            Act as an independent review gate. Inspect the requested diff and
            enough surrounding code and tests to validate behavior.

            Report only concrete findings, ordered by severity, with file and
            line references. Prioritize bugs, behavioral regressions, security
            problems, and missing tests. Ignore cosmetic style unless it
            creates a correctness or maintenance risk. Verify every claim. If
            there are no findings, say so and identify residual testing risks.

            Use only the allowed exact Git commands. Do not edit files,
            delegate work, or research external documentation.
          '';
        };
      };
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
        ];
        environment.PLAYWRIGHT_MCP_USER_DATA_DIR = "${config.xdg.cacheHome}/playwright-mcp";
        enabled = true;
      };
    };
    direnv.enable = true;
    gh.enable = true;
  };
}
