{ pkgs, ... }: {
  config = {
    ############################################################################
    # Install System Apps
    ############################################################################
    environment.systemPackages = with pkgs; [
      albert
      #cairo-dock
      #cairo-dock-plug-ins
      gitFull  # git, git gui, git-lfs
      kdePackages.plasma-sdk  # for cuttlefish (iconexplorer)
      sticky
      tilix
      thunar
      wget
      zsh
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
