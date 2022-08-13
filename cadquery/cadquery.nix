{ cadquery-src, python, ocp, git }:

python.pkgs.buildPythonPackage rec {
  pname = "cadquery";
  version = "2.1";

  src = "${cadquery-src}";

  patches = [
    ./sources.patch
  ];

  preBuild = ''
    export SETUPTOOLS_SCM_PRETEND_VERSION="${version}"
  '';

  nativeBuildInputs = [ git ];

  buildInputs = with python.pkgs; [
    setuptools-scm
  ];

  propagatedBuildInputs = with python.pkgs; [
    casadi
    ezdxf
    multimethod
    nlopt
    nptyping
    numpy
    ocp
    pathpy
    pyparsing
    typing-extensions
    typish
    vtk_9
  ];

  checkInputs = with python.pkgs; [
    docutils
    ipython
    pathpy
    pytest
  ];
}
