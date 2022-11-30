{ pkgs ? import <nixpkgs> { }, version, hash }:
pkgs.stdenv.mkDerivation rec {
  name = "balena-cli";

  src = pkgs.fetchzip {
    url = "https://github.com/balena-io/balena-cli/releases/download/v${version}/balena-cli-v${version}-macOS-x64-standalone.zip";
    sha256 = "${hash}";
  };

  installPhase = ''
    mkdir -p $out/balena-cli
    mkdir -p $out/bin 
    cp -r * $out/balena-cli
    ln -s $out/balena-cli/balena $out/bin/balena 
  '';
}
