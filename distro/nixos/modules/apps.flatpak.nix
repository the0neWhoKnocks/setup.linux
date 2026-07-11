{ pkgs, ... }: {
  config = {
    ############################################################################
    # Enable Flatpak
    ############################################################################
    services.flatpak.enable = true;
    #xdg.portal.enable = true;
    #xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    systemd.services.flatpak-repo = {
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.flatpak ];
      script = ''
        flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
      '';
    };
    
    ############################################################################
    # Install System Apps
    ############################################################################
    environment.systemPackages = with pkgs; [
      vlc
    ];
    
    ############################################################################
    # Install User Apps
    ############################################################################
    # users.users."<USER>" = {
    #   packages = with pkgs; [
    #     # package names here
    #   ];
    # };
  };
}
