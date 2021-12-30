{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

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
    pkgs.tmux
  ];

  # Raw configuration files
  home.file.".vimrc".source = ./vimrc;
  home.file.".vimrc.local".source = ./vimrc.local;
  home.file.".vimrc.local.bundles".source = ./vimrc.local.bundles;
  home.file.".config/nvim/init.vim".source = ./nvim-init.vim;
  home.file.".tmux.conf".source = ./tmux.conf;

  # Git config using Home Manager modules
  programs.git = {
    enable = true;
    userName = "flalanne";
    userEmail = "felipe@balena.io";
  };


  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";
}
