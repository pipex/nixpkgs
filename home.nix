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
    pkgs.nodejs-16_x
    pkgs.fzf
    pkgs.ripgrep
    pkgs.neovim
    pkgs.tmux
    pkgs.curl
    pkgs.nixpkgs-fmt
    pkgs.openssh
    pkgs.lazygit
    pkgs.stylua
    pkgs.shellcheck
    pkgs.bash # for tmux plugins
    pkgs.nodePackages.prettier
    pkgs.dbus
    pkgs.docker-client
  ];

  # Install AstroVim
  xdg.configFile."nvim".recursive = true;
  xdg.configFile."nvim".source = pkgs.fetchFromGitHub {
    owner = "AstroNvim";
    repo = "AstroNvim";
    rev = "nightly";
    # sha256 = "15zdx0nbg60xb4rs05bx5jywp9nyxagb9h94rawvnvhqpy05b8rw";
    sha256 = "0833wgw58984fhks0zkaqn9wa7vwnw8n3sl6d57myqqpdbzyr39q";
  };
  xdg.configFile."nvim/lua/user".source = pkgs.fetchFromGitHub {
    owner = "pipex";
    repo = "astrovim";
    # rev = "d28f19e8a2420babeb033b71373e5e5d0d9179a5";
    rev = "736219d6caffde63aea44ee9802e28edbbec75eb";
    sha256 = "1awq23rkfywi55hlvjl4srll6zans80rj4z58839x7ng27x5vrbf";
    # sha256 = "0d50ip112c9jrbldh9k2h8jqzmsynz5l4ypcmgcyirs06qrla3yv";
  };
  # xdg.configFile."nvim/lua/user".source = ./astrovim;

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
      balena = "sudo -E docker";
      shutdown = "dbus-send --system --print-reply --dest=org.freedesktop.login1 /org/freedesktop/login1 'org.freedesktop.login1.Manager.PowerOff' boolean:true";
      reboot = "dbus-send --system --print-reply --dest=org.freedesktop.login1 /org/freedesktop/login1 'org.freedesktop.login1.Manager.Reboot' boolean:true";
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
