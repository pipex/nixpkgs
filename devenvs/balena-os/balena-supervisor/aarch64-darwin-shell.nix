# shell.nix
{ pkgs ? import <nixpkgs> { } }:
(pkgs.mkShell.override {
  stdenv = pkgs.clangStdenv;
}) {
  GIT_REPO = "balena-os/balena-supervisor";
  nativeBuildInputs = [ pkgs.darwin.cctools ];
  buildInputs = [
    pkgs.pkg-config
    pkgs.dbus
    pkgs.nodejs-16_x
  ];
}
