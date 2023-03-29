{ pkgs ? import <nixpkgs> { } }:
pkgs.python3.pkgs.buildPythonPackage rec {
  name = "shell-gpt";
  version = "0.8.1";

  src = builtins.fetchTarball {
    url = "https://github.com/TheR1D/shell_gpt/releases/download/${version}/shell_gpt-${version}.tar.gz";
    sha256 = "1qsv02jc4i8h43ndk2bj0z2j0aqg3dn3pywnzqd5j21b0p7s170c";
  };

  doCheck = false;

  propagatedBuildInputs = with pkgs.python3.pkgs; [ distro typer rich requests ];
} 
