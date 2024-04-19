{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    {
      self,
      flake-utils,
      nixpkgs,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = (import nixpkgs) { inherit system; };
        python3Packages = pkgs.python3Packages;
      in
      rec {
        packages.default = python3Packages.buildPythonApplication {
          pname = "solo1-cli";
          version = "0.1.0";
          src = ./.;
          pyproject = true;

          build-system = with python3Packages; [
            flit
          ];


          dependencies = with python3Packages; [
            click
            cryptography
            ecdsa
            fido2
            intelhex
            pyserial
            pyusb
            requests
          ];

          meta = {
              mainProgram = "solo1";
          };
        };

        devShells.default = pkgs.mkShell { inputsFrom = [ packages.default ]; };
        formatter = pkgs.nixfmt-rfc-style;
      }
    );
}
