# NOTE: To export your Tilix config, run: dconf dump /com/gexperts/Tilix/ > ~/tilix.dconf

{ pkgs, ... }: {
  config = {
    environment.systemPackages = with pkgs; [
      tilix
      vte  # for tilix
    ];
    
    programs.zsh.vteIntegration = true; # Fix for Tilix
  };
}
