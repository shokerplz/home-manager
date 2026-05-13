{...}: {
  flake.homeModules.commonDefault = {
    pkgs,
    ...
  }: {
    home.sessionVariables = {
      EDITOR = "nvim";
    };

    home.packages = with pkgs; [
      fd
      gcc
      git
      jq
      ripgrep
      xclip
      dconf
      yq
    ];

    programs.home-manager.enable = true;

    programs.bash = {
      enable = true;
      sessionVariables = {
        TERMINAL = "alacritty";
      };
      historyControl = [
        "ignoredups"
        "ignorespace"
      ];
    };

    programs.starship = {
      enable = true;
      settings = {
        format = "$directory$git_branch$git_status$character";
        git_branch = {
          format = "[git:$branch(:$remote_branch)]($style) ";
          always_show_remote = true;
        };
        git_status = {
          format = "([$all_status$ahead_behind]($style) )";
          ahead = "^\${count}";
          behind = "v\${count}";
          diverged = "^\${ahead_count}v\${behind_count}";
          untracked = "?\${count}";
          stashed = "*\${count}";
          modified = "!\${count}";
          staged = "+\${count}";
          renamed = ">\${count}";
          deleted = "x\${count}";
        };
      };
    };

    programs.tmux = {
      enable = true;
      mouse = true;
      clock24 = true;
      plugins = [pkgs.tmuxPlugins.yank];
      extraConfig = ''
        set -ga terminal-overrides ',*256color*:smcup@:rmcup@'
        set -g @yank_selection_mouse 'clipboard'
        set -s set-clipboard on
      '';
    };

    programs.keychain = {
      enable = true;
      keys = ["~/.ssh/do_key"];
      extraFlags = ["--quiet"];
    };

  };
}
