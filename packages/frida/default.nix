{ lib, fetchPypi, python, frida-core, ... }:
let
  pname = "frida";
  name = pname;
  version = "16.0.11";

  meta = with lib; {
    description = "Python bindings for Frida.";
    platforms = platforms.all;
    homepage = "https://frida.re/";
    downloadPage = "https://github.com/frida/frida/releases";
    license = licenses.wxWindows;
  };

  inherit (python) buildPythonPackage typing-extensions;

  buildInputs = [ typing-extensions ];

in buildPythonPackage {
  inherit pname name version meta buildInputs;

  FRIDA_CORE_DEVKIT = "${frida-core}/share";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-73eTS0OBcfexc5NuLqHnjE5+U9iTVeWkUyL+H23rcHk=";
  };

  doCheck = false;
}
