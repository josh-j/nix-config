{
  pkgs,
  inputs,
  username,
  ...
}: let
  extraPackages = with pkgs; [
    # Development tools
    tree-sitter

    # C/CPP
    gcc
    ccls # c / c++

    # Go
    go
    gopls
    golangci-lint

    # Javascript
    nodejs
    nodePackages.npm
    nodePackages.prettier
    typescript
    # nodePackages.pyright
    nodePackages.typescript-language-server
    nodePackages.yaml-language-server
    nodePackages.vscode-langservers-extracted # html, css, json, eslint

    # Lua
    lua
    luarocks
    sumneko-lua-language-server
    lua52Packages.luacheck

    # Nix
    nil
    alejandra
    deadnix # nix
    nixpkgs-fmt
    statix # nix

    # Powershell
    powershell

    # Python
    virtualenv
    python3
    python3Packages.pip
    black # python
    ruff # python

    # Rust
    cargo-cache
    cargo-expand
    rustup

    # Sh
    shellcheck
    shfmt

    # Sql
    sqlfluff

    # Terraform
    tflint

    # System tools
    # clippy
    glow
    mkalias
    pngpaste

    # Terminal and shell
    neofetch
    # oh-my-zsh
    # starship
    # zoxide
    # zsh
    # zsh-autosuggestions
    # zsh-syntax-highlighting

    # UI
    aerospace
    raycast
    # microsoft-edge
    vscode
    siovim
    # jeezyvim
    # neovim
    # ...
    # steam
    spotify
    obsidian
  ];

  extraUnstablePackages = with pkgs.unstable; [
    # Development tools
    zed-editor
    fx # JSON viewer in terminal
    git-crypt

    # LSP
    neocmakelsp

    # Python
    uv # better python package manager

    # Terminal and shell
    zsh-autosuggestions
    zsh-syntax-highlighting

    # misc
    # flk-zen-browser
  ];
in {
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    global.brewfile = true;
    brews = ["cowsay"];
    casks = ["ghostty"];
  };
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${username} = {...}: {
      imports = [
        ../home.nix
        # ../../modules/common
        # ../../modules/darwin
        ../../programs/atuin.nix
        ../../programs/starship.nix
        ../../programs/wezterm.nix
        ../../programs/zoxide.nix
        ../../programs/zsh.nix
        ../../programs/tmux.nix
      ];
      _module.args = {
        inherit inputs username;
      };
      home = {
        packages = extraPackages ++ extraUnstablePackages;
        file = {
          ".aerospace.toml".text = builtins.readFile ../../programs/dotfiles/aerospace/aerospace.toml;
        };
      };
    };
  };
}