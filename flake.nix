{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:
    let
      out = system:
        let
          overlay = final: prev: { };
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ overlay ];
          };
        in {
          packages = with pkgs; {
            default = stdenv.mkDerivation {
              name = "looking-glass-viewer";
              src = ./build;
              buildPhase = "true";
              installPhase = ''
                cp -rf . $out
                ls -al .
                chmod +x $out/run.sh
                mkdir $out/bin
                mv $out/run-stdin.sh $out/bin/looking-glass-viewer-stdin
                mv $out/run.sh $out/bin/looking-glass-viewer
              '';
            };
          };
          devShell =
            pkgs.mkShell { buildInputs = [ pkgs.yarn pkgs.webpack-cli ]; };

        };
    in with utils.lib; eachSystem defaultSystems out;
}
