{ pkgs, ... }: {
  config = {
    environment.systemPackages = with pkgs; [
      lsd
    ];
    
    # Add global config for `lsd`
    environment.etc = {
      "lsd/config.yaml" = {
        source = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/the0neWhoKnocks/setup.linux/refs/heads/main/files/lsd/config.yaml";
          sha256 = "VWYbnF4ntDLztBIFuvImP0Csz4cDmLya5K74OEgAm34=";
        };
      };
    };
    
    environment.shellAliases = {
      d = "docker";
      dc = "docker compose";
      ll = "lsd -la";
      lsd = "lsd --config-file /etc/lsd/config.yaml";  # lsd doesn't seem to check for a global config, so make all lsd calls use a custom config path
      ss = "exec $SHELL";
      sudo="sudo ";  # Make aliases available while using `sudo`.
      # nix specific
      build-conf = "sudo nixos-rebuild switch --show-trace";
      build-home = "home-manager switch";
    };

    programs.nano = with pkgs; {
      enable = true;
      nanorc = ''
        set autoindent
        set indicator
        set linenumbers
        set mouse
        set tabsize 2
        set tabstospaces
        
        # Include default syntax files provided by Nixpkgs
        include "${nano}/share/nano/*.nanorc"
      '';
    };
    
    # NOTE: Adding zsh via `programs` adds files like `.zshrc` to `/etc/`.
    # `oh-my-zsh`'s folder can be found with `echo $ZSH`. I tried to create a
    # symlink into `$ZSH/custom/themes` but it's a read-only system so I'm
    # pointing `custom` to a path that is accessible by all.
    programs.zsh = {
      enable = true;
      autosuggestions = {
        enable = true;
        strategy = [ "history" ];
      };
      histSize = 1000000;
      setOptions = [
        "HIST_FCNTL_LOCK"  # When writing out the history file, by default zsh uses ad-hoc file locking to avoid known problems with locking on some operating systems. With this option locking is done by means of the system’s fcntl call, where this method is available. On recent operating systems this may provide better performance, in particular avoiding history corruption when files are stored on NFS.
        "HIST_IGNORE_ALL_DUPS"  # If a new command line being added to the history list duplicates an older one, the older command is removed from the list (even if it is not the previous event).
        "HIST_REDUCE_BLANKS"  # Remove superfluous blanks from each command line being added to the history list.
        "HIST_SAVE_NO_DUPS"  # When writing out the history file, older commands that duplicate newer ones are omitted.
        "HIST_VERIFY"  # Whenever the user enters a line with history expansion, don’t execute the line directly; instead, perform history expansion and reload the line into the editing buffer.
        "NO_BEEP"  # Don't make beep sounds
        "NOTIFY"  # Report the status of background jobs immediately, rather than waiting until just before printing a prompt.
      ];
      syntaxHighlighting.enable = false;
    };
    
    # # Prevent the new user dialog in zsh
    # system.userActivationScripts.zshrc = "touch .zshrc";
    # Set zsh as the default shell for all users
    users.defaultUserShell = pkgs.zsh;
    # Allow GDM/display managers to detect users with zsh
    environment.shells = with pkgs; [ zsh ];
  };
}
