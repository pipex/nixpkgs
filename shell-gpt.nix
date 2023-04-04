{ pkgs ? import <nixpkgs> { } }:
pkgs.python3.pkgs.buildPythonPackage rec {
  name = "shell-gpt";
  version = "0.8.3";

  src = builtins.fetchTarball {
    url = "https://github.com/TheR1D/shell_gpt/releases/download/${version}/shell_gpt-${version}.tar.gz";
    sha256 = "1lcx0dlrlfa3pb62p1lb9y330dc6sgh41w3x74rg3jrv81krlbbb";
  };

  doCheck = false;

  propagatedBuildInputs = with pkgs.python3.pkgs; [ distro typer rich requests ];
} 
