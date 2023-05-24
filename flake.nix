{
  description = "A language server implementation for Google Protocol Buffers";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    gomod2nix = {
      url = "github:tweag/gomod2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, gomod2nix }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ gomod2nix.overlays.default ];
          };
        in
        {
          packages.default = pkgs.buildGoApplication {
            pname = "pls";
            version = "0.1";
            src = ./.;
            modules = ./gomod2nix.toml;
          };

          devShells.default = pkgs.mkShell {
            buildInputs = with pkgs; [
              go
              gopls
              gotools
              go-tools
              gomod2nix.packages.${system}.default
            ];
          };
        }
      );
}
