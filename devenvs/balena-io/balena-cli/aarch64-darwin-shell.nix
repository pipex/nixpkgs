# shell.nix
{ pkgs ? import <nixpkgs> { } }:
let
  frameworks = pkgs.darwin.apple_sdk.frameworks;
in
(pkgs.mkShell.override {
  stdenv = pkgs.clangStdenv;
}) {
  GIT_REPO = "balena-io/balena-cli";
  nativeBuildInputs = [ pkgs.darwin.cctools ];
  buildInputs = [
    pkgs.python3
    pkgs.pkg-config
    pkgs.zlib
    pkgs.openssl
    pkgs.git
    pkgs.which
    pkgs.xcbuild
    pkgs.nodejs-14_x
    frameworks.IOKit
    frameworks.Security
    frameworks.DiskArbitration
    frameworks.Foundation
    frameworks.Cocoa
  ];
}
