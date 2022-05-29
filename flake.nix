{
  description = "A simple flake";

  inputs = {
    nixpkgs = {
      type = "indirect";
      id = "nixpkgs-unstable";
    };
    flake-utils.url = "github:numtide/flake-utils";
    nix-things = {
      url = "git+https://codeberg.org/Uli/nix-things.git?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pywrap-src = {
      url = "github:WizardUli/pywrap/dev";
      flake = false;
    };
    ocp-src = {
      url = "github:WizardUli/OCP/dev";
      flake = false;
    };
    cadquery-src = {
      url = "github:WizardUli/cadquery/dev";
      flake = false;
    };
    cq-editor-src = {
      url = "github:WizardUli/CQ-editor/dev";
      flake = false;
    };
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    , nix-things
    , pywrap-src
    , ocp-src
    , cadquery-src
    , cq-editor-src
    }:

    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; overlays = [ nix-things.overlays.cq ]; };
      llvmPackages = pkgs.llvmPackages_10;
      python = pkgs.python3;
    in
    {
      packages = {
        pywrap = pkgs.callPackage pywrap/pywrap.nix {
          inherit pywrap-src python;
        };
        cadquery = pkgs.callPackage cadquery/cadquery.nix {
          inherit cadquery-src python;
          inherit (self.packages.${system}) ocp;
        };
        cq-editor = pkgs.callPackage cq-editor/cq-editor.nix {
          inherit cq-editor-src python;
          inherit (self.packages.${system}) cadquery;
        };
      }
      //
      (import ./ocp {
        inherit ocp-src pkgs llvmPackages python;
        inherit (self.packages.${system}) pywrap;
      });

      devShells.default = pkgs.mkShell {
        packages = with pkgs; [ ];
      };
    }
    );
}
