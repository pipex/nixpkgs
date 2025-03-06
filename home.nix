{ config
, pkgs
, lib
, ...
}:
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "felipe";
  home.homeDirectory = "/home/felipe";
  home.sessionVars = {
    SWEET_HOME_SHELL="zsh";
  };

  fonts.fontconfig.enable = true;

    # Packages to install
  home.packages = with pkgs; [
    # pkgs is the set of all packages in the default home.nix implementation
    gnumake
    gcc
    ripgrep
    curl
    openssh
    lazygit
    nixpkgs-fmt
    jq
    yq-go
    mosh
    bash
    shellcheck
    libiconv
    colordiff
    (callPackage ./balena-cli.nix {
      hash = "1il7c4blkhk5n290b2dmgxmz05fv2hy1rirmjf2pfm5mk3iqbp9d";
      version = "20.2.1";
    })
    # (pkgs.callPackage ./shell-gpt.nix { })
    nerd-fonts.sauce-code-pro
    nodejs_22 # A JavaScript runtime built on Chrome's V8 JavaScript engine
    bun
    shellcheck # shell script analysis tool
    shfmt # A shell parser, formatter, and interpreter (POSIX/Bash/mksh)
    rustup # Rust updater
    alejandra # The Uncompromising Nix Code Formatter
    deadnix # Nix
    statix # Nix
    go # Golang
    hadolint # Dockerfile linter, validate inline bash scripts
    luarocks # Lua linter
    nixd
    go
    bottom
    docker
  ];

  # Install AstroVim
  xdg.configFile."nvim".recursive = true;
  xdg.configFile."nvim".source = pkgs.fetchFromGitHub {
    owner = "pipex";
    repo = "astrovim";
    rev = "7192b23";
    sha256 = "0nv001daa6x72d6xsx8797w4jgs33q2c2sg4mm3fis8ks20bz903";
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

  # Prettier
  home.file.".prettierrc.json".source = ./prettierrc.json;
  # Avoid bugs with npm like https://github.com/NixOS/nixpkgs/issues/16441
  home.file.".npmrc".text = lib.generators.toINIWithGlobalSection { } {
    globalSection = {
      prefix = "~/.npm";
    };
  };

  # Global shell aliases
  home.shellAliases = {
    balena-staging = "BALENARC_BALENA_URL=balena-staging.com BALENARC_DATA_DIRECTORY=~/.balenaStaging balena";
    balena-support = "BALENARC_DATA_DIRECTORY=~/.balenaSupport balena";
    vi = "nvim";
    lg = "lazygit";
    cd = "z";
  };

  programs.tmux = {
    enable = true;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
  };

  # A modern replacement for ‘ls’
  # useful in bash/zsh prompt, not in nushell.
  programs.eza = {
    enable = true;
    git = true;
    icons = "auto";
  };

  # skim provides a single executable: sk.
  # Basically anywhere you would want to use grep, try sk instead.
  programs.skim = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.gpg = {
    enable = true;
  };

  # Git config using Home Manager modules
  programs.git = {
    enable = true;
    # lfs.enable = true;
    package = pkgs.gitAndTools.gitFull;
    userName = "Felipe Lalanne";
    userEmail = "felipe@lalanne.cl";

    ignores = [
      ".DS_Store"
      "*.pyc"
      "node_modules/"
      ".envrc"
      ".direnv*"
      ".devenv*"
    ];

    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      color = {
        ui = true;
      };
      push = {
        default = "current";
        autoSetupRemote = true;
      };
      pull = {
        ff = "only";
        rebase = true;
      };
      core = {
        editor = "nvim";
      };
    };

    signing = {
      key = "2CE4D30172CD04D5";
      signByDefault = true;
    };

    # https://nix-community.github.io/home-manager/options.html#opt-programs.git.delta.enable
    # https://github.com/dandavison/delta
    delta = {
      enable = true;
      # options = {
      #   features = "side-by-side";
      # };
    };

    aliases = {
      # common aliases
      br = "branch";
      co = "checkout";
      st = "status";
      ls = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate";
      ll = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate --numstat";
      lg = "log --graph --pretty='\''%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'\'' --all";
      cm = "commit -m";
      ca = "commit -am";
      dc = "diff --cached";
      amend = "commit --amend '-S'";

      # aliases for submodule
      update = "submodule update --init --recursive";
      foreach = "submodule foreach";
    };
  };

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    nix-direnv = {
      enable = true;
    };
  };

  programs.gh = {
    enable = true;
    settings.git_protocol = "ssh";
    gitCredentialHelper.enable = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    autocd = true;

    localVariables = {
      TZ = "America/Santiago";
      EDITOR = "nvim";
      # TERM = "screen-256color";
    };
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
    profileExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin:$HOME/.npm/bin:$HOME/.cargo/bin"
    '';
    initExtra = ''
      export BALENARC_NO_ANALYTICS=1
      export BUILDKIT_PROGRESS=plain
      export GPG_TTY=$(tty)

      cb() {
        if [ -d .git ]; then
          ([ "$GIT_REPO_HOME" = "" ] || [ ! -d "$GIT_REPO_HOME" ]) && echo "Already in a git repository and not GIT_REPO_HOME defined" && return 1
          cd $GIT_REPO_HOME
        fi

        repo="$GIT_REPO"
        folder="$1"
        branch="$1"

        [ "$repo" = "" ] && echo "No GIT_REPO environment variable" && return 1

        if [ "$folder" = "" ]; then
          branch="$(git ls-remote --symref "git@github.com:$repo.git" HEAD | awk '/^ref:/ {sub(/refs\/heads\//, "", $2); print $2}')"
          folder="$branch"
        fi

        if [ -d "$folder" ]; then
          cd "$folder"
          [ ! -d ".git" ] && echo "Folder $folder exists but is not a git repository" && return 1
          return 0
        fi

        git clone --recurse-submodules "git@github.com:$repo.git" $folder && \
          cd $folder && \
          (git checkout $branch || git checkout -b $branch)

        if [ -f "package-lock.json" ]; then
          npm ci
        elif [ -f "package.json" ]; then
          npm i
        fi
      }
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [ "git docker" ];
      custom = "${config.xdg.configHome}/oh-my-zsh";
      theme = "pipex";
      extraConfig = ''
        DISABLE_MAGIC_FUNCTIONS="true";
      '';
    };

    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.8.0";
          sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
        };
      }
    ];
  };

  programs.starship = {
    enable = true;

    enableBashIntegration = true;
    enableZshIntegration = true;

    settings = {
      # add_newline = false;

      # character = {
      #   success_symbol = "[➜](bold green)";
      #   error_symbol = "[➜](bold red)";
      # };

      package.disabled = true;

      # https://starship.rs/presets/plain-text.html

      character = {
        success_symbol = "[>](bold green)";
        error_symbol = "[x](bold red)";
        vimcmd_symbol = "[<](bold green)";
      };
      docker_context = {
        disabled = true;
      };
      container = {
        disabled = true;
      };
      golang = {
        symbol = "go ";
      };
      lua = {
        symbol = "lua ";
      };
      nodejs = {
        symbol = "nodejs ";
      };
      nix_shell = {
        disabled = true;
      };
      python = {
        symbol = "python ";
      };
      rust = {
        symbol = "rust ";
      };
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
  home.stateVersion = "24.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
