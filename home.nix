{ config, pkgs, lib, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "flalanne";
  home.homeDirectory = "/Users/flalanne";
  home.sessionVariables = {
    # SWEET_HOME_SHELL = "zsh";
  };

  # Packages to install
  home.packages = [
    # pkgs is the set of all packages in the default home.nix implementation
    pkgs.gnumake
    pkgs.gcc
    # pkgs.nodejs-16_x
    pkgs.fzf
    pkgs.ripgrep
    pkgs.neovim
    pkgs.tmux
    pkgs.curl
    pkgs.openssh
    pkgs.lazygit
    pkgs.dbus
    pkgs.cargo
    pkgs.rustc
    pkgs.nixpkgs-fmt
  ];

  # Install AstroVim
  xdg.configFile."nvim".recursive = true;
  xdg.configFile."nvim".source = pkgs.fetchFromGitHub {
    owner = "AstroNvim";
    repo = "AstroNvim";
    rev = "v2.0.0";
    sha256 = "1ps73ay6pl5hrkq9r3gavgs4vk9cgazqa2rqsyq8yhb8q0wjba8q";
  };
  # xdg.configFile."nvim/lua/user".source = pkgs.fetchFromGitHub {
  #   owner = "pipex";
  #   repo = "astrovim";
  #   rev = "736219d6caffde63aea44ee9802e28edbbec75eb";
  #   sha256 = "1awq23rkfywi55hlvjl4srll6zans80rj4z58839x7ng27x5vrbf";
  # };
  xdg.configFile."nvim/lua/user".source = ./astronvim;

  xdg.configFile."oh-my-zsh".source = ./oh-my-zsh;

  home.file.".tmux.conf".source = ./tmux/tmux.conf;
  home.file.".tmux".recursive = true;
  home.file.".tmux".source = ./tmux;
  home.file.".tmux/plugins/tpm".source = pkgs.fetchFromGitHub {
    owner = "tmux-plugins";
    repo = "tpm";
    rev = "v3.0.0";
    sha256 = "18q5j92fzmxwg8g9mzgdi5klfzcz0z01gr8q2y9hi4h4n864r059";
  };

  # Git config using Home Manager modules
  programs.git = {
    enable = true;
    userName = "pipex";
    userEmail = "1822826+pipex@users.noreply.github.com";
  };

  programs.autojump = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      ll = "ls -l";
      update = "home-manager switch";
      vi = "nvim";
      lg = "lazygit";
    };
    localVariables = {
      TZ = "America/Santiago";
      TERM = "screen-256color";
    };
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      custom = "${config.xdg.configHome}/oh-my-zsh";
      theme = "pipex";
    };
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

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
