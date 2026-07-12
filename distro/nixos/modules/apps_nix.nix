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
      gitFull  # git, git gui, git-lfs
      kdePackages.plasma-sdk  # for cuttlefish (iconexplorer)
      sticky
      tilix
      thunar
      wget
    ];
  };
}
