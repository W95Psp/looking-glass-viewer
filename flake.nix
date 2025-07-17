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
            default = stdenv.mkDerivation (finalAttrs: {
              name = "looking-glass-viewer";

              src = ./.;

              yarnOfflineCache = fetchYarnDeps {
                yarnLock = finalAttrs.src + "/yarn.lock";
                hash = "sha256-Rgn8Y+ES8QSUNhvvAhPvq8rtyUtQyjWCK7R6hNwyyvY=";
              };

              nativeBuildInputs =
                [ yarnConfigHook yarnBuildHook yarnInstallHook nodejs ];

              buildPhase = ''
                yarn
                yarn build
                ls -al
                xxxx
              '';
            });
          };
          devShell =
            pkgs.mkShell { buildInputs = [ pkgs.yarn pkgs.webpack-cli ]; };

        };
    in with utils.lib; eachSystem defaultSystems out;

}
