{ cq-editor-src, python, cadquery, qt5 }:

python.pkgs.buildPythonApplication {
  pname = "cq-editor";
  version = "0.3.0dev";
  src = cq-editor-src;

  nativeBuildInputs = [
    qt5.wrapQtAppsHook
    qt5.qtwayland
  ];
  dontWrapQtApps = true;

  buildInputs = [ qt5.qtbase ];

  propagatedBuildInputs = with python.pkgs; [
    cadquery
    Logbook
    pyqt5
    pyqtgraph
    spyder
  ];

  preFixup = ''
    wrapQtApp "$out/bin/cq-editor"
    # https://github.com/CadQuery/CQ-editor/issues/266
    wrapProgram "$out/bin/cq-editor" --set QT_QPA_PLATFORM xcb
  '';

  doCheck = false;
}
