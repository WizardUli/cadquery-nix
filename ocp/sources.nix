{ ocp-src
, lib
, llvmPackages
, ocp-symbols
, python
, pywrap
, opencascade-occt
, libGL
, rapidjson
, xorg
}:

let
  buildStdenv = llvmPackages.stdenv;
in
buildStdenv.mkDerivation {
  name = "ocp-sources";
  srcs = map (s: "${ocp-src}/${s}") [
    "ocp.toml"
    "templates"
    "OCP_specific.inc"
    "pystreambuf.h"
    "vtk_pybind.h"
  ];

  buildInputs = [
    libGL
    pywrap
    rapidjson
    xorg.libX11
  ];

  unpackPhase = ''
    runHook preUnpack

    for srcEntry in $srcs; do
      srcName="$(stripHash "$srcEntry")"
      cp -r "$srcEntry" "$srcName"
      chmod -R +w "$srcName"
    done

    runHook postUnpack
  '';

  configurePhase = ''
    runHook preConfigure

    cp "${ocp-symbols}/symbols_mangled_linux.dat" ./

    BINDGEN_CFLAGS="$(< ${buildStdenv.cc}/nix-support/libc-crt1-cflags) \
      $(< ${buildStdenv.cc}/nix-support/libc-cflags) \
      $(< ${buildStdenv.cc}/nix-support/cc-cflags) \
      $(< ${buildStdenv.cc}/nix-support/libcxx-cxxflags) \
      ${lib.optionalString buildStdenv.cc.isClang "-idirafter ${buildStdenv.cc.cc.lib}/lib/clang/${lib.getVersion buildStdenv.cc.cc}/include"} \
      ${lib.optionalString buildStdenv.cc.isGNU "-isystem ${lib.getDev buildStdenv.cc.cc}/include/c++/${lib.getVersion buildStdenv.cc.cc} -isystem ${buildStdenv.cc.cc}/include/c++/${lib.getVersion buildStdenv.cc.cc}/${buildStdenv.hostPlatform.config}"} \
      "-I${python.pkgs.vtk_9}/include/vtk-9.0" \
      $NIX_CFLAGS_COMPILE"

    python "${./configure_ocp.py}" \
      --input-folder "${opencascade-occt}/include/opencascade" \
      --args-whitespace-separated "$BINDGEN_CFLAGS"
    
    runHook postConfigure
  '';

  buildPhase =
    let
      clang_library_file = "${llvmPackages.libclang.lib}/lib/libclang${buildStdenv.targetPlatform.extensions.sharedLibrary}";
    in
    ''
      runHook preBuild

      echo "Doing bindgen parse" &&
      python -m bindgen -n "$NIX_BUILD_CORES" --libclang "${clang_library_file}" parse ocp.toml out.pkl &&
      echo "Doing bindgen transform" &&
      python -m bindgen -n "$NIX_BUILD_CORES" --libclang "${clang_library_file}" transform ocp.toml out.pkl out_f.pkl &&
      echo "Doing bindgen generate" &&
      python -m bindgen -n "$NIX_BUILD_CORES" --libclang "${clang_library_file}" generate ocp.toml out_f.pkl &&
      echo "Finished bindgen" || exit 1

      runHook postBuild
    '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"
    cp -r ./OCP "$out/"

    runHook postInstall
  '';
}
