{ llvmPackages
, python
, opencascade-occt
, clang_10
, cmake
, rapidjson
, xorg
, libGL
, ocp-sources
}:

llvmPackages.stdenv.mkDerivation {
  name = "ocp-library";

  buildInputs = [
    llvmPackages.libcxx
    clang_10
    opencascade-occt
    cmake
    rapidjson
    xorg.libX11
    libGL
  ] ++ (with python.pkgs; [
    pybind11
    vtk_9
  ]);

  unpackPhase = ''
    runHook preUnpack

    cp -r "${ocp-sources}/OCP"/* ./

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"
    cp OCP.*.so "$out/"

    runHook postInstall
  '';
}
