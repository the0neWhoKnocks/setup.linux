{ pkgs, ... }: {
  config = {
    environment.systemPackages = with pkgs; [
      ##########################################################################
      ## Nix Specific
      ##########################################################################
      home-manager  # system for managing a user environment - allows for declarative configuration of user specific (non global) packages and dotfiles.
      ## -----------------------------------------------------------------------
      albert
      #cairo-dock
      #cairo-dock-plug-ins
      featherpad
      kdePackages.plasma-sdk  # for cuttlefish (iconexplorer)
      sticky
      thunar
      wget
    ];
    
    programs = {
      git = with pkgs; {
        enable = true;
        package = gitFull; # git, git gui, git-lfs
        lfs.enable = true;
      };
    };
    
    virtualisation.docker.enable = true;
    #virtualisation.docker.daemon.settings = {
    #  data-root = <NEW_PATH>;
    #};
    #users.groups.docker.members = [ "<USER1>" "<USER2>" ];
  };
}
