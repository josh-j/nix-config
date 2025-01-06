{
  config,
  pkgs,
  ...
}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    # Use fast-syntax-highlighting instead of regular syntax highlighting
    syntaxHighlighting.enable = false;
    autosuggestions.enable = true;

    defaultKeymap = "emacs";

    # Optimized completion init
    completionInit = ''
      # Setup fpath for completions
      fpath=(
        ${config.xdg.cacheHome}/zsh/completions
        $fpath
        ${pkgs.zsh}/share/zsh/site-functions
        ${pkgs.zsh}/share/zsh/${pkgs.zsh.version}/functions
      )

      # Load completions
      autoload -Uz compinit bashcompinit

      # Only regenerate completion cache once per day
      if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
        compinit
        bashcompinit
      else
        compinit -C
        bashcompinit -C
      fi

      # Completion styles
      zstyle ':completion:*' menu select
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
      zstyle ':completion:*' verbose true
      zstyle ':completion:*' group-name '''' # group matches by tag
      zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
      zstyle ':completion:*:*:*:*:descriptions' format '%F{blue}-- %D %d --%f'
      zstyle ':completion:*:*:*:*:messages' format ' %F{purple} -- %d --%f'
      zstyle ':completion:*:*:*:*:warnings' format ' %F{red}-- no matches found --%f'
    '';

    # History settings optimized for performance
    history = {
      save = 10000;
      size = 10000;
      expireDuplicatesFirst = true;
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    sessionVariables = {
      ALTERNATE_EDITOR = "${pkgs.vim}/bin/vi";
      LC_CTYPE = "en_US.UTF-8";
      LEDGER_COLOR = "true";
      LESS = "-FRSXM";
      LESSCHARSET = "utf-8";
      PAGER = "less";
      TINC_USE_NIX = "yes";
      WORDCHARS = "";

      ZSH_THEME_GIT_PROMPT_CACHE = "yes";
      ZSH_THEME_GIT_PROMPT_CHANGED = "%{$fg[yellow]%}%{✚%G%}";
      ZSH_THEME_GIT_PROMPT_STASHED = "%{$fg_bold[yellow]%}%{⚑%G%}";
      ZSH_THEME_GIT_PROMPT_UPSTREAM_FRONT = " {%{$fg[yellow]%}";

      ITERM_ENABLE_SHELL_INTEGRATION_WITH_TMUX = "YES";
    };

    # Keep essential plugins and add autosuggestions
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git" # Keep for git aliases and completions
        "zoxide" # Keep for directory jumping
        "direnv" # Keep for development environments
        # "zsh-autosuggestions" # Add autosuggestions
      ];
    };

    # Enable autosuggestions explicitly
    autosuggestion.enable = true;

    # Initialize zsh faster by deferring source loading
    initExtraFirst = ''
      # Profile startup when needed
      if [[ "$PROFILE_STARTUP" == true ]]; then
        zmodload zsh/zprof
      fi

      # Create completion cache directory
      mkdir -p ${config.xdg.cacheHome}/zsh/completions

      # Load completion system
      autoload -Uz compinit

      # Ensure compdef is available
      autoload -Uz compdef
    '';

    initExtra = ''
      # Lazy load completions
      eval "$(${pkgs.starship}/bin/starship init zsh)"

      kubectl() {
        unfunction "$0"
        source <(command kubectl completion zsh)
        $0 "$@"
      }

      helm() {
        unfunction "$0"
        source <(command helm completion zsh)
        $0 "$@"
      }

      docker-compose() {
        unfunction "$0"
        source <(command docker-compose completion zsh)
        $0 "$@"
      }

      # Load zoxide after compinit
      eval "$(${pkgs.zoxide}/bin/zoxide init zsh)"

      # Load atuin if zle is available
      if [[ $options[zle] = on ]]; then
        eval "$(${pkgs.atuin}/bin/atuin init zsh)"
      fi

      # Profile output
      if [[ "$PROFILE_STARTUP" == true ]]; then
        zprof
      fi
    '';

    shellAliases = {
      # Keep your existing aliases
      "...." = "././..";
      cd = "z";
      gc = "nix-collect-garbage --delete-old";
      refresh = "source ${config.home.homeDirectory}/.zshrc";
      show_path = "echo $PATH | tr ':' '\n'";
      # Git aliases
      gapa = "git add --patch";
      grpa = "git reset --patch";
      gst = "git status";
      gdh = "git diff HEAD";
      gp = "git push";
      gph = "git push -u origin HEAD";
      gco = "git checkout";
      gcob = "git checkout -b";
      gcm = "git checkout master";
      gcd = "git checkout develop";
      # Docker aliases
      dco = "docker compose";
      dps = "docker ps";
      dpa = "docker ps -a";
      dl = "docker ps -l -q";
      dx = "docker exec -it";
      ls = "eza";
      dotfiles = "git --git-dir=$HOME/Projects/dotfiles/ --work-tree=$HOME";
    };
  };

  # Add XDG Base Directory support
  xdg.enable = true;

  # Ensure completion cache directory exists
  home.file.".cache/zsh/completions/.keep".text = "";
}
