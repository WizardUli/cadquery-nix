{ ocp-src, pkgs, llvmPackages, python, pywrap }:

rec {
  ocp-symbols = pkgs.callPackage ./symbols.nix { inherit ocp-src llvmPackages python; };
  ocp-sources = pkgs.callPackage ./sources.nix { inherit ocp-src llvmPackages python ocp-symbols pywrap; };
  ocp-library = pkgs.callPackage ./library.nix { inherit llvmPackages python ocp-sources; };
  ocp = pkgs.callPackage ./ocp.nix { inherit python ocp-library; };
}
