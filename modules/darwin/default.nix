{
  pkgs,
  username,
  ...
}: {
  imports = [
    # ./programs/aerospace.nix
  ];

  environment = {
    systemPackages = with pkgs; [
      # ghostty.packages.${pkgs.system}.default
      qmk
      # zsh
      # zsh-nix-shell
    ];
  };

  # Determinate compatibility
  nix.extraOptions = ''
    auto-optimise-store = true
    experimental-features = nix-command flakes
  '';

  system.primaryUser = "joshj";
  programs.nix-index.enable = true;
  programs.zsh.enable = true; # breaks /run/current-system/sw/bin
  # programs.nu.enable = true;

  nix = {
    enable = false; # determinate
    # nix.optimise.automatic = false;
    # nix.gc.automatic = false;
    # configureBuildUsers = false;J
    # useDaemon = false; # Let Determinate manage the daemon
    settings = {
      trusted-users = [username];
      access-tokens = let
        getSecret = key: ''
          $(if [ -f "$HOME/.secrets.json" ]; then
            jq -r '.${key} // empty' "$HOME/.secrets.json"
          fi)'';
      in [
        "github.com=${getSecret "github_pat_token"}"
      ];
    };
  };

  # services.jankyborders = {
  #   enable = true;
  #   active_color = "0x7705f5e5";
  #   # active_color = "0xaaff9999";
  #   inactive_color = "";
  #   width = 1.0;
  # };

  homebrew = {
    enable = true;
    # brewPrefix = "/run/current-system/sw/bin/brew";
    onActivation = {
      cleanup = "zap";
      upgrade = true;
      autoUpdate = true;
      extraFlags = ["--force"];
    };

    global = {
      # Automatically use the Brewfile that this module generates in the Nix store
      # https://daiderd.com/nix-darwin/manual/index.html#opt-homebrew.global.brewfile
      brewfile = true;
      autoUpdate = true;
      lockfiles = false;
    };

    taps = [
      # "qmk/qmk"
      # "FelixKratz/formulae"
    ];
    brews = [
      # "openssl@3"
      # "firefoxpwa"
      "uvicorn"
      # "jankyborders"
    ];

    casks = [
      # "font-sf-mono-nerd-font-ligaturized"
      # "nextcloud"
      "moonlight"
      "anki"
      # {
      #   name = "microsoft-edge";
      #   greedy = true;
      # }
      # "gcc-arm-embedded"
      "ghostty"
      # "parsec"
      "obsidian"
      {
        name = "brave-browser";
        greedy = true;
      }
      # {
      #   name = "google-chrome";
      #   greedy = true;
      # }
      "scroll-reverser"
      # "steam"
      # {
      #   name = "zen-browser";
      #   greedy = true;
      # }
      "vlc"
      "zed"
    ];
  };

  users.users.${username} = {
    name = "${username}";
    home = "/Users/${username}";
    shell = pkgs.nushell;
  };

  system = {
    stateVersion = 5;
    # activationScripts.postUserActivation.text = ''
    #   # activateSettings -u will reload the settings from the database and apply them to the current session,
    #   # so we do not need to logout and login again to make the changes take effect.
    #   /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    # '';

    defaults = {
      loginwindow.GuestEnabled = false;

      CustomUserPreferences = {
        "com.apple.security.smartcard" = {
          # allowSmartCard = false;
          enforceSmartCard = false;
        };
        "com.apple.commerce".AutoUpdate = true;
        "com.apple.desktopservices" = {
          # Avoid creating .DS_Store files on network or USB volumes
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
        };
        "com.apple.finder" = {
          ShowExternalHardDrivesOnDesktop = false;
          ShowHardDrivesOnDesktop = false;
          ShowMountedServersOnDesktop = true;
          ShowRemovableMediaOnDesktop = true;
          _FXSortFoldersFirst = true;
          # When performing a search, search the current folder by default
          FXDefaultSearchScope = "SCcf";
        };
        # "com.apple.spaces" = {
        #   "spans-displays" = true;
        # };
      };

      dock = {
        autohide = true;
        autohide-delay = 0.0;
        autohide-time-modifier = 0.1;
        expose-animation-duration = 0.1;
        expose-group-apps = true;
        launchanim = false;
        mru-spaces = false;
        orientation = "bottom";
        persistent-apps = [
          # "${pkgs.spotify}/Applications/Spotify.app"
          # "${pkgs.wezterm}/Applications/Wezterm.app"
          "/Applications/Ghostty.app"
          # "/Applications/Microsoft Edge.app"
          "${pkgs.vscode}/Applications/Visual Studio Code.app"
          # "${pkgs.alacritty}/Applications/Alacritty.app"
          # "${pkgs.obsidian}/Applications/Obsidian.app"
        ];
        show-process-indicators = true;
        show-recents = false;
        showhidden = true;
        static-only = false;
        tilesize = 48;
      };

      finder = {
        AppleShowAllExtensions = true;
        FXEnableExtensionChangeWarning = false;
        FXPreferredViewStyle = "clmv";
        ShowPathbar = true;
        _FXShowPosixPathInTitle = true;
      };

      LaunchServices = {
        LSQuarantine = false;
      };

      NSGlobalDomain = {
        "com.apple.keyboard.fnState" = true;
        "com.apple.mouse.tapBehavior" = 1;
        "com.apple.sound.beep.feedback" = 0;
        "com.apple.sound.beep.volume" = 0.0;
        "com.apple.springing.delay" = 0.1;
        AppleInterfaceStyle = "Dark";
        AppleKeyboardUIMode = 3;
        ApplePressAndHoldEnabled = false;
        AppleShowAllExtensions = true;
        InitialKeyRepeat = 15; # 120, 94, 68, 35, 25, 15
        KeyRepeat = 2; # 120, 90, 60, 30, 12, 6, 2
        NSAutomaticWindowAnimationsEnabled = false;
        NSNavPanelExpandedStateForSaveMode = true;
        NSNavPanelExpandedStateForSaveMode2 = true;
        NSWindowResizeTime = 0.001;
        NSDocumentSaveNewDocumentsToCloud = false; # Faster file operations
        NSTextShowsControlCharacters = true;
        NSDisableAutomaticTermination = true;
        NSWindowShouldDragOnGesture = true;
        # _HIHideMenuBar = true;
      };

      screencapture.location = "~/Pictures/screenshots";
      screensaver.askForPasswordDelay = 10;

      trackpad = {
        Clicking = true;
        # TrackpadThreeFingerDrag = true;
      };
    };
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = false;
      userKeyMapping = [
        {
          HIDKeyboardModifierMappingSrc = 30064771129; # Caps Lock
          HIDKeyboardModifierMappingDst = 30064771363; # Left Command

          # HIDKeyboardModifierMappingSrc = 29360128100; # The function key
          # HIDKeyboardModifierMappingDst = 64424509440; # Hyper key   }
        }
      ];
    };
  };
}
