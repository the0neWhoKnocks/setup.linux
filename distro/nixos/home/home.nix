# Current default location: ~/.config/home-manager/home.nix
# Folder may not exist so run: mkdir -p ~/.config/home-manager
# Apply this file to system: home-manager switch

{ config, pkgs, ... }:
let
  USER = builtins.getEnv "USER";
in {
  home.username = "${USER}";
  home.homeDirectory = "/home/${USER}";
  
  # home.packages = with pkgs; [
  #   # 
  # ];
  
  dconf.settings = {
    "com/gexperts/Tilix" = {
      copy-on-select = true;
      quake-specific-monitor = 0;
      theme-variant = "dark";
      window-save-state = true;
      window-state = 128;
    };

    "com/gexperts/Tilix/keybindings" = {
      terminal-paste = "<Primary>v";
    };

    "com/gexperts/Tilix/profiles/2b7c4080-0ddd-46c5-8f23-563fd3ba789d" = {
      background-color = "#111111111111";
      dim-transparency-percent = 46;
      font = "FantasqueSansM Nerd Font Mono 16";
      foreground-color = "#AAAAAAAAAAAA";
      palette = [
        "#070735354242"
        "#DCDC31312F2F"
        "#858599990000"
        "#B5B589890000"
        "#26268A8AD2D2"
        "#D3D336368181"
        "#2929A1A19898"
        "#EEEEE8E8D5D5"
        "#444444444444"
        "#D2D228284747"
        "#9F9FCACA5656"
        "#FBFB77774242"
        "#5555B5B5DBDB"
        "#6C6C7171C4C4"
        "#4343C1C1D0D0"
        "#FDFDF6F6E3E3"
      ];
      use-system-font = false;
      use-theme-colors = false;
      visible-name = "Default";
    };
  };
  
  programs.home-manager.enable = true;
  
  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "26.05";
}
