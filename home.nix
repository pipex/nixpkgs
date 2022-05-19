{ config, pkgs, lib, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "me";
  home.homeDirectory = "/home/me";
  home.sessionVariables = {
    SWEET_HOME_SHELL = "zsh";
  };

  # Packages to install
  home.packages = [
    # pkgs is the set of all packages in the default home.nix implementation
    pkgs.gnumake
    pkgs.gcc
    pkgs.nodejs
    pkgs.fzf
    pkgs.ripgrep
    pkgs.neovim
    pkgs.tmux
    pkgs.curl
    pkgs.nixpkgs-fmt
    pkgs.openssh
    pkgs.lazygit
    pkgs.stylua
    pkgs.bash
  ];

  # Install AstroVim
  xdg.configFile."nvim".recursive = true;
  xdg.configFile."nvim".source = pkgs.fetchFromGitHub {
    owner = "AstroNvim";
    repo = "AstroNvim";
    rev = "2aa0dee65a890f7a61b66a7b0b51257805303c10";
    sha256 = "0sbrbzn4krlh7b1x45ac8pqc37yib9b48vrssw6qvl5y456n6kyv";
  };
  xdg.configFile."nvim/lua/user".source = pkgs.fetchFromGitHub {
    owner = "pipex";
    repo = "astrovim";
    rev = "709167a514cd15110889d73ca6c994b6dfaf6a3f";
    sha256 = "18nn2zixrmj6ml0hrbzmfzk9sv4773120a53h8h2g92ybhaqjp5y";
  };

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
  home.stateVersion = "21.05";
}
