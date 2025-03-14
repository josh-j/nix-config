# programs/zellij.nix
{
  pkgs,
  inputs,
  ...
}: let
  plugin_zjstatus = inputs.zjstatus.outputs.packages.${pkgs.stdenv.hostPlatform.system}.default;
  yazi-plugins = pkgs.fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "687f6f2a97ef7c691d623d910989f1a8dfdc0d7e";
    hash = "sha256-tiJ/eDvUPqux33owjE4y5eLGJeT9GW4qQItPSC5i/nc=";
  };
in {
  programs.nushell.shellAliases = {
    he = "zellij -s $'($env.PWD | path basename)-(random int)' --new-session-with-layout /users/joshj/.config/zellij/layouts/helix.kdl";
  };

  programs.zellij = {
    enable = true;
    enableBashIntegration = false;
    enableFishIntegration = false;
    enableZshIntegration = false;
  };

  xdg.configFile = {
    "zellij/plugins/zellij_forgot.wasm".source = pkgs.fetchurl {
      url = "https://github.com/karimould/zellij-forgot/releases/download/0.4.1/zellij_forgot.wasm";
      sha256 = "1pxwy5ld3affpzf20i1zvn3am12vs6jwp06wbshw4g1xw8drj4ch";
    };
    "zellij/plugins/zjstatus.wasm".source = "${plugin_zjstatus}/bin/zjstatus.wasm";
    "zellij/yazi/plugins/no-status.yazi".source = "${yazi-plugins}/no-status.yazi";
    "zellij/yazi/plugins/smart-filter.yazi".source = "${yazi-plugins}/smart-filter.yazi";
    "zellij/yazi/theme.toml".source = "${pkgs.custom.catppuccin-yazi}/themes/mocha/catppuccin-mocha-mauve.toml";
    "zellij/yazi/Catppuccin-mocha.tmTheme".source = "${pkgs.custom.catppuccin-bat}/themes/Catppuccin Mocha.tmTheme";
  };
}
