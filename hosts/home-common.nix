{
  pkgs,
  username,
  ...
}: let
  homeDirectory =
    if pkgs.stdenv.isDarwin
    then "/Users/${username}"
    else "/home/${username}";

  extraPackages = with pkgs; [
    # Development tools
    direnv
    docker
    docker-compose
    gh
    gnupg
    httpie
    just
    lazygit
    mkcert
    sshs # TUI for ~/.ssh/config
    tldr # tdlr for shell commands

    # System tools
    mkalias
    fd # fast find
    mosh # better ssh
    procs # better ps
    ripgrep
    sd # better sed and awk
    unzip
    evil-helix # better no-config vim
    wget
    yazi
    zip

    # Terminal and shell
    # atuin
    carapace # multi-environment shell completion
    eza
    fzf
    bat
    bottom # system monitor
    coreutils
    curl
    du-dust # better du cmd
    findutils
    git-crypt
    htop
    jq
    killall
    # oh-my-zsh
    # zsh
    # zsh-autosuggestions
    # zsh-syntax-highlighting
  ];
in {
  imports = [
    ../programs/git.nix
    ../programs/ssh.nix
  ];
  home = {
    inherit username homeDirectory;

    packages = extraPackages;
    sessionPath = [
      # "$HOME/.local/bin"
      # "$HOME/.local/share/bin"
      # "/opt/homebrew/bin" # FIXME don't add if not darwin
    ];

    sessionVariables = let
      getSecret = key: ''
        $(if [ -f "$HOME/.secrets.json" ]; then
          jq -r '.${key} // empty' "$HOME/.secrets.json"
        fi)'';
    in {
      ANTHROPIC_API_KEY = getSecret "anthropic_api";
      GITHUB_TOKEN = getSecret "github_token"; # Example of another secret
      OPENAI_API_KEY = getSecret "openai_api"; # Another example
      OPENROUTER_API_KEY = getSecret "openrouter_api"; # Another example
      # Add as many secrets as you need
    };

    stateVersion = "24.11";
  };

  programs = {
    home-manager = {
      enable = true;
    };
    nix-index = {
      enable = true;
      enableZshIntegration = false;
    };
  };
}
