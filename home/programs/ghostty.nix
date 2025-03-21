{lib, ...}: {
  programs.ghostty = {
    enable = true;
    package = null; # You're using Homebrew
    enableBashIntegration = false; # Manual setup required
    enableZshIntegration = false; # Manual setup required
    installBatSyntax = false; # No Nix package
    installVimSyntax = false; # No Nix package

    settings = {
      # theme = "oxocarbon";
      # theme = "rosepine-moon";
      theme = "Builtin Solarized Light";

      window-vsync = true;
      # font-family = "Iosevka Nerd Font";
      font-family = "Liga SFMono Nerd Font";
      font-style = "medium";
      font-feature = [
        "calt"
        "dlig"
        "ss05"
      ];
      font-thicken = true;
      font-size = 13;
      window-inherit-font-size = true;

      adjust-cursor-thickness = 3;
      adjust-underline-position = 3;
      # background-opacity = 0.93;
      # background-blur-radius = 20;
      window-decoration = true;
      window-padding-x = 4;
      window-padding-y = 4;
      window-padding-color = "extend-always";
      window-padding-balance = false;
      window-theme = "auto";

      bold-is-bright = true;
      link-url = true;
      mouse-hide-while-typing = true;

      macos-titlebar-style = "hidden";
      macos-option-as-alt = true;
      macos-auto-secure-input = true;
      macos-secure-input-indication = true;
      auto-update = "off";

      working-directory = "home";

      clipboard-paste-protection = true;
      clipboard-trim-trailing-spaces = true;
      copy-on-select = true;
      scrollback-limit = 100000;
      shell-integration = "zsh"; # Only affects the *config file*, not integration itself
      shell-integration-features = "cursor,sudo,title";

      keybind = "ctrl+shift+r=reload_config";
    };
  };

  # Override the onChange attributes using lib.mkForce
  # home.file."/Users/joshj/.config/ghostty/config".onChange = lib.mkForce "";
  # xdg.configFile."ghostty/themes".source = lib.mkForce { };
}
