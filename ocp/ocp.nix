{ python, ocp-library, writeText }:

python.pkgs.buildPythonPackage {
  pname = "OCP";
  version = "0.0.0";
  src = ocp-library;
  format = "pyproject";

  prePatch =
    let
      pyproject = writeText "pyproject.toml" ''
        [build-system]
        requires = [
            "setuptools>=42",
            "wheel"
        ]
        build-backend = "setuptools.build_meta"
      '';

      setup_cfg = writeText "setup.cfg" ''
        [metadata]
        name = OCP

        [options]
        packages = .

        [options.package_data]
        * = *.so
      '';
    in
    ''
      cp "${pyproject}" ./pyproject.toml;
      cp "${setup_cfg}" ./setup.cfg
      ls -la
    '';

  pythonImportsCheck = [ "OCP" "OCP.gp" ];
}
