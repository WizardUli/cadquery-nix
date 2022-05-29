{ pywrap-src, pkgs, lib, python }:

python.pkgs.buildPythonPackage {
  pname = "pywrap";
  version = "0.1dev";

  src = pywrap-src;

  # patches = [ ./path_module.patch ];

  propagatedBuildInputs = with python.pkgs; [
    libclang_10
    click
    jinja2
    joblib
    logzero
    pandas
    path
    pybind11
    pyparsing
    schema
    toml
    toposort
    tqdm
  ];
}
