{ config, pkgs, lib, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "me";
  home.homeDirectory = "/home/me";

  # Packages to install
  home.packages = [
    # pkgs is the set of all packages in the default home.nix implementation
    pkgs.gnumake
    pkgs.gcc
    pkgs.nodejs-12_x
    pkgs.fzf
    pkgs.ripgrep
    pkgs.neovim
    pkgs.procps
    pkgs.tmux
    pkgs.curl
  ];
  
  # Raw configuration files
  home.file.".tmux/plugins/tpm".source = ./tools/tpm;
  home.file.".config/nvim".source = ./AstroVim;
  home.file.".tmux.conf".source = ./tmux.conf;

  # Git config using Home Manager modules
  programs.git = {
    enable = false;
    userName = "flalanne";
    userEmail = "felipe@balena.io";
  };

  programs.zsh = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
      update = "home-manager switch";
      vi = "nvim";
    };
    localVariables={
      TZ = "America/Santiago";
    };
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "theunraveler";
    };
  };

  # Run additional scripts after install
  home.activation = {
    syncPackages = lib.hm.dag.entryAfter ["writeBoundary"] ''
      DRY=$DRY_RUN_CMD

      # Install nvim packages
      $DRY nvim --headless +PackerSync -c 'autocmd User PackerComplete quitall'
    '';
  };


  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.05";
}
