{ lib, fetchPypi, python, ... }:
let
  pname = "frida-tools";
  name = pname;
  version = "12.1.1";

  meta = with lib; {
    description = "CLI tools for Frida.";
    platforms = platforms.all;
    homepage = "https://frida.re/";
    downloadPage = "https://github.com/frida/frida-tools/tags";
    license = licenses.wxWindows;
  };

  inherit (python) buildPythonPackage;

in buildPythonPackage {
  inherit pname name version meta;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-k7Wbxeyca1r9jrNzK+q5K/EGQhG/Zgbqy/VAEYoWB+U=";
  };

  doCheck = false;
}
