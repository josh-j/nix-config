{ config, lib, pkgs, ... }: {
  # Security settings
  security = {
    pam.enableSudoTouchIdAuth = lib.mkIf (config.system.platform == "darwin") true;
  };
  
  # System security features
  # Linux-specific SSH configuration
  services.openssh = lib.mkIf (!pkgs.stdenv.isDarwin) {
    enable = lib.mkDefault false;
  };

  # Darwin-specific SSH configuration
  services.sshd = lib.mkIf pkgs.stdenv.isDarwin {
    enable = lib.mkDefault false;
  };
}
