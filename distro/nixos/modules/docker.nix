{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkMerge mkOption types;
  
  cfg = config.mine.docker;
in {
  options.mine.docker = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Docker";
    };
    
    dataRoot = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Change where Docker stores it's data";
    };
    
    users = mkOption {
      type = types.nullOr (types.listOf types.str);
      default = null;
      description = "Users that'll be added to the Docker group";
      example = "[ \"user1\" \"user2\" ]";
    };
  };
  
  config = mkIf cfg.enable (mkMerge [
    {
      # Enable the docker daemon.
      virtualisation.docker.enable = true;
    }
    
    # Change Docker's `data-root` if a different path was specified.
    (mkIf (cfg.dataRoot != null) {
      virtualisation.docker.daemon.settings = {
        data-root = cfg.dataRoot;
      };
    })
      
    (mkIf (cfg.users != null) {
      # Add specified users to the `docker` group.
      users.groups.docker.members = cfg.users;
    })
  ]);
}
