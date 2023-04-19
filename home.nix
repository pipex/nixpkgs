{ config, pkgs, lib, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "flalanne";
  home.homeDirectory = "/Users/flalanne";

  fonts.fontconfig.enable = true;

  # Packages to install
  home.packages = [
    # pkgs is the set of all packages in the default home.nix implementation
    pkgs.gnumake
    pkgs.gcc
    pkgs.fzf
    pkgs.ripgrep
    pkgs.neovim
    pkgs.tmux
    pkgs.curl
    pkgs.openssh
    pkgs.lazygit
    pkgs.rustup
    pkgs.nixpkgs-fmt
    pkgs.rust-analyzer
    pkgs.jq
    pkgs.yq
    pkgs.mosh
    pkgs.bash
    pkgs.shellcheck
    pkgs.reattach-to-user-namespace
    pkgs.libiconv
    pkgs.colordiff
    (pkgs.callPackage ./balena-cli.nix {
      version = "15.1.0";
      hash = "0ad2w1yk2dhj0jd1lmak2i5zrpkbspf9nfm4q10vbah8ajw1g49q";
    })
    (pkgs.callPackage ./shell-gpt.nix { })
    (pkgs.nerdfonts.override { fonts = [ "SourceCodePro" ]; })
    pkgs.gh
    pkgs.go
  ];

  # Install AstroVim
  xdg.configFile."nvim".recursive = true;
  xdg.configFile."nvim".source = pkgs.fetchFromGitHub {
    owner = "AstroNvim";
    repo = "AstroNvim";
    rev = "v3.10.3";
    sha256 = "1ba0xjjcf56qvappc6mlxw9i9kz5y706h4gkzhq6qb9vvq3s4m80";
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

  # Prettier
  home.file.".prettierrc".source = ./prettierrc;

  # Git config using Home Manager modules
  programs.git = {
    enable = true;
    userName = "Felipe Lalanne";
    userEmail = "1822826+pipex@users.noreply.github.com";
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      push = {
        autoSetupRemote = true;
      };
      pull = {
        rebase = true;
      };
      core = {
        editor = "nvim";
      };
    };
    aliases = {
      lg = "log --graph --pretty='\''%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'\'' --all";
    };
  };

  programs.autojump = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.direnv = {
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
      EDITOR = "nvim";
      # TERM = "screen-256color";
    };
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
    initExtra = ''
      export NVM_DIR="$HOME/.nvm"
      [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
      [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

      cs() {
        folder=$1
        branch=$1
        if [ "$folder" = "" ]; then
          folder="balena-supervisor"
          branch=master
        fi
        git clone git@github.com:balena-os/balena-supervisor.git $folder && \
          cd $folder && \
          (git checkout $branch || git checkout -b $branch) && \
          nix-shell -p dbus pkg-config --run "npm ci"
      }
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      custom = "${config.xdg.configHome}/oh-my-zsh";
      theme = "pipex";
    };

    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.5.0";
          sha256 = "0za4aiwwrlawnia4f29msk822rj9bgcygw6a8a6iikiwzjjz0g91";
        };
      }
    ];
  };


  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
