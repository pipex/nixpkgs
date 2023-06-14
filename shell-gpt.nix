{ pkgs ? import <nixpkgs> { } }:
pkgs.python3.pkgs.buildPythonPackage rec {
  name = "shell-gpt";
  version = "0.9.3";
  format = "pyproject";

  src = builtins.fetchTarball {
    url = "https://github.com/TheR1D/shell_gpt/releases/download/${version}/shell_gpt-${version}.tar.gz";
    sha256 = "0wkvk8gvyp24mq9nfjqw3apkr1xgcmvhgznwj3c8lqk4k4xwzyf6";
  };

  doCheck = false;

  # Modify the pyproject.toml to use the latest version of rich which is available
  # in nix-unstable  
  preBuild = ''
    sed 's/rich >= 10.11.0, < 13.0.0/rich >= 10.11.0, <=13.3.1/' -i pyproject.toml
  '';

  propagatedBuildInputs = with pkgs.python3.pkgs;
    [ distro typer rich requests hatchling ];
} 
