{ ocp-src, llvmPackages, opencascade-occt, python }:

llvmPackages.stdenv.mkDerivation {
  name = "ocp-symbols";
  src = "${ocp-src}/dump_exported_symbols.py";

  buildInputs = [
    python
    python.pkgs.lief
  ];

  unpackPhase = ''
    runHook preUnpack
    cp "$src" "$(stripHash "$src")"
    runHook postUnpack
  '';

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild

    python ./dump_exported_symbols.py \
      --lib-ver "${opencascade-occt.version}" \
      --lib-dir "${opencascade-occt}/lib" \
      --out "symbols_mangled_linux.dat"

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"
    cp symbols_mangled_linux.dat "$out/"

    runHook postInstall
  '';
}
